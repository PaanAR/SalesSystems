<?php
require_once 'security.php';
secure_session_start();
check_user_type(2); // 2 for clerk
require_once 'db_connection.php';

// Fetch today's statistics with more details
$today = date('Y-m-d');
$stmt = $conn->prepare("
    SELECT 
        COUNT(*) as total_orders,
        SUM(total_amount) as total_sales,
        COUNT(CASE WHEN payment_method = 'cash' THEN 1 END) as cash_orders,
        SUM(CASE WHEN payment_method = 'cash' THEN total_amount ELSE 0 END) as cash_sales,
        COUNT(CASE WHEN payment_method = 'card' THEN 1 END) as card_orders,
        SUM(CASE WHEN payment_method = 'card' THEN total_amount ELSE 0 END) as card_sales
    FROM orders 
    WHERE DATE(order_date) = ? 
    AND clerk_id = ? 
    AND payment_status = 'paid'
    AND order_type = 'in-store'
");

$stmt->bind_param("si", $today, $_SESSION['user']['id']);
$stmt->execute();
$daily_stats = $stmt->get_result()->fetch_assoc();

// Handle null values
$daily_stats = array_map(function($value) {
    return $value ?? 0;
}, $daily_stats);

// Fetch recent completed orders with more details
$stmt = $conn->prepare("
    SELECT 
        o.id,
        o.order_number,
        o.order_date,
        o.total_amount,
        o.payment_method,
        GROUP_CONCAT(
            CONCAT(oi.quantity, 'x ', i.product_name, ' (RM', FORMAT(oi.unit_price, 2), ')')
            SEPARATOR ', '
        ) as items
    FROM orders o 
    LEFT JOIN order_items oi ON o.id = oi.order_id 
    LEFT JOIN inventory i ON oi.product_id = i.id
    WHERE o.clerk_id = ? 
    AND o.status = 'completed'
    GROUP BY o.id 
    ORDER BY o.order_date DESC 
    LIMIT 5
");
$stmt->bind_param("i", $_SESSION['user']['id']);
$stmt->execute();
$recent_orders = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Fetch active inventory
$stmt = $conn->prepare("SELECT * FROM inventory WHERE status = 'active' AND stock_level > 0 ORDER BY category, product_name");
$stmt->execute();
$products = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Group products by category
$categorized_products = [];
foreach ($products as $product) {
    $categorized_products[$product['category']][] = $product;
}

// Process new order
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['place_order'])) {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        die('Invalid CSRF token');
    }

    try {
        $conn->begin_transaction();
        
        // Get customer details
        $customer_name = htmlspecialchars(trim($_POST['customer_name']));
        $customer_contact = htmlspecialchars(trim($_POST['customer_contact']));
        
        // Create walk-in guest record
        $stmt = $conn->prepare("
            INSERT INTO guest (
                fullname, 
                contact, 
                address, 
                email, 
                password, 
                type, 
                date_created
            ) VALUES (?, ?, '-', CONCAT('walk-in-', ?), '', 3, NOW())
        ");
        $stmt->bind_param("sss", $customer_name, $customer_contact, time());
        $stmt->execute();
        $guest_id = $conn->insert_id;
        
        // Create order
        $order_number = 'POS' . time();
        $total_amount = 0;
        $payment_method = $_POST['payment_method'];
        
        // Calculate total and validate stock
        foreach ($_POST['quantity'] as $product_id => $quantity) {
            if ($quantity > 0) {
                $stmt = $conn->prepare("SELECT unit_price, stock_level FROM inventory WHERE id = ?");
                $stmt->bind_param("i", $product_id);
                $stmt->execute();
                $product = $stmt->get_result()->fetch_assoc();
                
                if ($quantity > $product['stock_level']) {
                    throw new Exception("Insufficient stock for product ID: " . $product_id);
                }
                
                $total_amount += $product['unit_price'] * $quantity;
            }
        }
        
        // Insert order with status 'completed' and payment_status 'paid'
        $stmt = $conn->prepare("
            INSERT INTO orders (
                order_number, 
                order_date, 
                total_amount, 
                status, 
                payment_method, 
                payment_status, 
                order_type, 
                clerk_id,
                guest_id
            ) VALUES (?, NOW(), ?, 'completed', ?, 'paid', 'in-store', ?, ?)
        ");
        $stmt->bind_param("sdsii", $order_number, $total_amount, $payment_method, $_SESSION['user']['id'], $guest_id);
        $stmt->execute();
        $order_id = $conn->insert_id;
        
        // Insert order items
        foreach ($_POST['quantity'] as $product_id => $quantity) {
            if ($quantity > 0) {
                $stmt = $conn->prepare("SELECT unit_price FROM inventory WHERE id = ?");
                $stmt->bind_param("i", $product_id);
                $stmt->execute();
                $product = $stmt->get_result()->fetch_assoc();
                
                $subtotal = $product['unit_price'] * $quantity;
                $stmt = $conn->prepare("
                    INSERT INTO order_items (
                        order_id, 
                        product_id, 
                        quantity, 
                        unit_price, 
                        subtotal
                    ) VALUES (?, ?, ?, ?, ?)
                ");
                $stmt->bind_param("iiids", $order_id, $product_id, $quantity, $product['unit_price'], $subtotal);
                $stmt->execute();
            }
        }
        
        $conn->commit();
        $_SESSION['success'] = "Order #$order_number completed successfully!";
        header("Location: print_receipt.php?order_id=" . $order_id);
        exit();
        
    } catch (Exception $e) {
        $conn->rollback();
        $_SESSION['error'] = "Error processing order: " . $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Clerk Dashboard - Roti Sri Bakery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand">Clerk Dashboard</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="clerk_dashboard.php">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="clerk_management.php">My Profile</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="completed_orders.php">Order History</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                    <span class="text-light me-3">Welcome, <?php echo htmlspecialchars($_SESSION['user']['fullname']); ?></span>
                    <a href="logout.php" class="btn btn-outline-light btn-sm">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <?php if (isset($_SESSION['error'])): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <?php 
                echo $_SESSION['error'];
                unset($_SESSION['error']);
                ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <?php if (isset($_SESSION['success'])): ?>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <?php 
                echo $_SESSION['success'];
                unset($_SESSION['success']);
                ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <!-- Daily Stats -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Today's Statistics</h5>
                        <div class="row g-3">
                            <div class="col-6">
                                <div class="border rounded p-2">
                                    <div class="text-muted small">Total Orders</div>
                                    <h3 class="mb-0"><?php echo $daily_stats['total_orders']; ?></h3>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="border rounded p-2">
                                    <div class="text-muted small">Total Sales</div>
                                    <h3 class="mb-0">RM<?php echo number_format($daily_stats['total_sales'], 2); ?></h3>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="border rounded p-2">
                                    <div class="text-muted small">Cash Sales</div>
                                    <div>Orders: <?php echo $daily_stats['cash_orders']; ?></div>
                                    <div>Amount: RM<?php echo number_format($daily_stats['cash_sales'], 2); ?></div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="border rounded p-2">
                                    <div class="text-muted small">Card Sales</div>
                                    <div>Orders: <?php echo $daily_stats['card_orders']; ?></div>
                                    <div>Amount: RM<?php echo number_format($daily_stats['card_sales'], 2); ?></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Quick Actions</h5>
                        <div class="d-flex gap-2">
                            <a href="clerk_management.php" class="btn btn-outline-primary flex-fill">
                                <i class="bi bi-person"></i> My Profile
                            </a>
                            <a href="completed_orders.php" class="btn btn-outline-success flex-fill">
                                <i class="bi bi-clock-history"></i> Order History
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Product Selection -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">New In-Store Order</h5>
                        <form method="POST" id="orderForm">
                            <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                            
                            <?php foreach ($categorized_products as $category => $products): ?>
                                <h6 class="mt-4"><?php echo htmlspecialchars($category); ?></h6>
                                <div class="row">
                                    <?php foreach ($products as $product): ?>
                                        <div class="col-md-6 mb-3">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h6><?php echo htmlspecialchars($product['product_name']); ?></h6>
                                                    <p class="mb-2">
                                                        Price: RM<?php echo number_format($product['unit_price'], 2); ?><br>
                                                        Stock: <?php echo $product['stock_level']; ?>
                                                    </p>
                                                    <div class="input-group">
                                                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="decrementQuantity(<?php echo $product['id']; ?>)">-</button>
                                                        <input type="number" class="form-control form-control-sm text-center quantity-input" 
                                                               name="quantity[<?php echo $product['id']; ?>]" 
                                                               value="0" min="0" max="<?php echo $product['stock_level']; ?>"
                                                               data-price="<?php echo $product['unit_price']; ?>"
                                                               onchange="updateTotal()">
                                                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="incrementQuantity(<?php echo $product['id']; ?>)">+</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    <?php endforeach; ?>
                                </div>
                            <?php endforeach; ?>
                    </div>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="col-md-4">
                <div class="card position-sticky" style="top: 1rem;">
                    <div class="card-body">
                        <h5 class="card-title">Order Summary</h5>
                        
                        <!-- Add Walk-in Customer Details -->
                        <div class="mb-3">
                            <label class="form-label">Customer Name</label>
                            <input type="text" name="customer_name" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Contact Number</label>
                            <input type="text" name="customer_contact" class="form-control" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Payment Method</label>
                            <select name="payment_method" class="form-select" required>
                                <option value="cash">Cash</option>
                                <option value="card">Card</option>
                            </select>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Total Items:</span>
                            <span id="totalItems">0</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                            <strong>Total Amount:</strong>
                            <strong>RM<span id="totalAmount">0.00</span></strong>
                        </div>
                        <button type="submit" name="place_order" class="btn btn-primary w-100" id="submitOrder" disabled>
                            Complete Order
                        </button>
                    </div>
                </div>

                <!-- Recent Orders -->
                <div class="card mt-3">
                    <div class="card-body">
                        <h5 class="card-title">Recent Orders</h5>
                        <?php if (empty($recent_orders)): ?>
                            <p class="text-muted">No recent orders</p>
                        <?php else: ?>
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Order #</th>
                                            <th>Time</th>
                                            <th>Items</th>
                                            <th>Amount</th>
                                            <th>Payment</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($recent_orders as $order): ?>
                                            <tr>
                                                <td><?php echo htmlspecialchars($order['order_number']); ?></td>
                                                <td><?php echo date('H:i', strtotime($order['order_date'])); ?></td>
                                                <td>
                                                    <small class="text-muted">
                                                        <?php echo htmlspecialchars($order['items']); ?>
                                                    </small>
                                                </td>
                                                <td>RM<?php echo number_format($order['total_amount'], 2); ?></td>
                                                <td>
                                                    <span class="badge bg-<?php echo $order['payment_method'] === 'cash' ? 'success' : 'info'; ?>">
                                                        <?php echo ucfirst($order['payment_method']); ?>
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="print_receipt.php?order_id=<?php echo $order['id']; ?>" 
                                                       class="btn btn-sm btn-outline-primary" 
                                                       title="Print Receipt">
                                                       <i class="bi bi-printer"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                            <div class="text-end mt-2">
                                <a href="completed_orders.php" class="btn btn-outline-primary btn-sm">
                                    View All Orders <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        <?php endif; ?>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function incrementQuantity(productId) {
            const input = document.querySelector(`input[name="quantity[${productId}]"]`);
            if (input.value < parseInt(input.max)) {
                input.value = parseInt(input.value) + 1;
                updateTotal();
            }
        }

        function decrementQuantity(productId) {
            const input = document.querySelector(`input[name="quantity[${productId}]"]`);
            if (input.value > 0) {
                input.value = parseInt(input.value) - 1;
                updateTotal();
            }
        }

        function updateTotal() {
            let totalItems = 0;
            let totalAmount = 0;
            
            document.querySelectorAll('.quantity-input').forEach(input => {
                const quantity = parseInt(input.value) || 0;
                const price = parseFloat(input.dataset.price);
                
                totalItems += quantity;
                totalAmount += quantity * price;
            });
            
            document.getElementById('totalItems').textContent = totalItems;
            document.getElementById('totalAmount').textContent = totalAmount.toFixed(2);
            
            // Enable/disable submit button based on items selected
            document.getElementById('submitOrder').disabled = totalItems === 0;
        }

        // Initialize total on page load
        updateTotal();
    </script>
</body>
</html> 