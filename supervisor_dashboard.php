<?php
require_once 'security.php';
secure_session_start();
check_user_type(1); // 1 for supervisor
require_once 'db_connection.php';
require_once 'fetch_sales.php'; // Ensure this file exists and is in the correct path
require_once 'fetch_inventory.php'; // Ensure this file exists and is in the correct path

// Initialize filter variables
$start_date = isset($_POST['start_date']) ? $_POST['start_date'] : date('Y-m-d', strtotime('-1 month'));
$end_date = isset($_POST['end_date']) ? $_POST['end_date'] : date('Y-m-d');
$sales_type = isset($_POST['sales_type']) ? $_POST['sales_type'] : 'all';

// Debugging output
echo "<pre>";
echo "Start Date: $start_date\n";
echo "End Date: $end_date\n";
echo "Sales Type: $sales_type\n";
echo "</pre>";

// Fetch sales data based on filters
list($daily_sales, $weekly_sales, $monthly_sales) = fetch_sales_data($conn, $start_date, $end_date, $sales_type);

// Fetch inventory data
$inventory_data = fetch_inventory_data($conn);
?>
<!DOCTYPE html>
<html>
<head>
    <title>Supervisor Dashboard - Roti Sri Bakery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Sales Reports</h2>

        <!-- Filter Form -->
        <form method="POST" class="mb-4">
            <div class="row">
                <div class="col-md-4">
                    <label for="start_date" class="form-label">Start Date</label>
                    <input type="date" class="form-control" name="start_date" value="<?php echo htmlspecialchars($start_date); ?>" required>
                </div>
                <div class="col-md-4">
                    <label for="end_date" class="form-label">End Date</label>
                    <input type="date" class="form-control" name="end_date" value="<?php echo htmlspecialchars($end_date); ?>" required>
                </div>
                <div class="col-md-4">
                    <label for="sales_type" class="form-label">Sales Type</label>
                    <select class="form-select" name="sales_type">
                        <option value="all" <?php echo $sales_type === 'all' ? 'selected' : ''; ?>>All</option>
                        <option value="online" <?php echo $sales_type === 'online' ? 'selected' : ''; ?>>Online</option>
                        <option value="in-store" <?php echo $sales_type === 'in-store' ? 'selected' : ''; ?>>In-Store</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="btn btn-primary mt-3">Filter</button>
        </form>

        <h3>Daily Sales</h3>
        <table class="table">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Total Revenue</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($daily_sales as $sale): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($sale['sale_date']); ?></td>
                        <td>RM<?php echo number_format($sale['total_revenue'], 2); ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
        
        <h3>Weekly Sales</h3>
        <table class="table">
            <thead>
                <tr>
                    <th>Week</th>
                    <th>Total Revenue</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($weekly_sales as $sale): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($sale['sale_week']); ?></td>
                        <td>RM<?php echo number_format($sale['total_revenue'], 2); ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
        
        <h3>Monthly Sales</h3>
        <table class="table">
            <thead>
                <tr>
                    <th>Month</th>
                    <th>Total Revenue</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($monthly_sales as $sale): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($sale['sale_month']); ?></td>
                        <td>RM<?php echo number_format($sale['total_revenue'], 2); ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

        <h2>Inventory Management</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Stock Level</th>
                    <th>Unit Price</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($inventory_data as $item): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($item['product_name']); ?></td>
                        <td><?php echo htmlspecialchars($item['stock_level']); ?></td>
                        <td>RM<?php echo number_format($item['unit_price'], 2); ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
    
</body>
</html>