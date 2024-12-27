<?php
require_once 'security.php';
secure_session_start();
check_user_type(1); // 1 for supervisor

// Add CSRF protection
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');
header('X-Content-Type-Options: nosniff');
?>
<!DOCTYPE html>
<html>
<head>
    <title>Supervisor Dashboard - Roti Sri Bakery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta http-equiv="Content-Security-Policy" content="default-src 'self' https://cdn.jsdelivr.net; script-src 'self' https://cdn.jsdelivr.net 'nonce-<?php echo $_SESSION['csrf_token']; ?>'; style-src 'self' https://cdn.jsdelivr.net;">
</head>
<body>
    <nav class="navbar navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand">Supervisor Dashboard</a>
            <div>
                <span class="text-light me-3">Welcome, <?php echo sanitize_output($_SESSION['user']['fullname']); ?></span>
                <form action="logout.php" method="POST" style="display: inline;">
                    <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                    <button type="submit" class="btn btn-outline-light btn-sm">Logout</button>
                </form>
            </div>
        </div>
    </nav>
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-4 mb-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Sales Reports</h5>
                        <p class="card-text">View and analyze sales data</p>
                        <a href="#" class="btn btn-primary">View Reports</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Staff Management</h5>
                        <p class="card-text">Manage clerk accounts</p>
                        <a href="#" class="btn btn-primary">Manage Staff</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Performance Metrics</h5>
                        <p class="card-text">View staff performance</p>
                        <a href="#" class="btn btn-primary">View Metrics</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 