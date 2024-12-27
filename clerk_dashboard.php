<?php
session_start();
if (!isset($_SESSION['user']) || $_SESSION['user']['type'] != 2) {
    header("Location: login.php");
    exit();
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Clerk Dashboard - Roti Sri Bakery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand">Clerk Dashboard</a>
            <div>
                <span class="text-light me-3">Welcome, <?php echo htmlspecialchars($_SESSION['user']['fullname']); ?></span>
                <a href="logout.php" class="btn btn-outline-light btn-sm">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-4 mb-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">New Order</h5>
                        <p class="card-text">Process new customer orders</p>
                        <a href="#" class="btn btn-primary">Create Order</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Inventory</h5>
                        <p class="card-text">Check current stock levels</p>
                        <a href="#" class="btn btn-primary">View Inventory</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Daily Sales</h5>
                        <p class="card-text">View today's sales</p>
                        <a href="#" class="btn btn-primary">View Sales</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 