<?php
require_once 'security.php';
secure_session_start();
require 'db_connection.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $fullname = htmlspecialchars(trim($_POST['fullname']), ENT_QUOTES, 'UTF-8');
    $contact = htmlspecialchars(trim($_POST['contact']), ENT_QUOTES, 'UTF-8');
    $address = htmlspecialchars(trim($_POST['address']), ENT_QUOTES, 'UTF-8');
    $email = filter_var(trim($_POST['email']), FILTER_SANITIZE_EMAIL);
    $password = $_POST['password'];
    $confirm_password = $_POST['confirm_password'];
    
    // Check if passwords match
    if ($password !== $confirm_password) {
        $_SESSION['error'] = "Passwords do not match.";
        header("Location: register.php");
        exit();
    }
    
    // Validate password strength
    if (strlen($password) < 8 || 
        !preg_match("/[A-Z]/", $password) || 
        !preg_match("/[a-z]/", $password) || 
        !preg_match("/[0-9]/", $password)) {
        $_SESSION['error'] = "Password must be at least 8 characters and include uppercase, lowercase, and numbers.";
        header("Location: register.php");
        exit();
    }
    
    $stmt = $conn->prepare("SELECT * FROM Guest WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        $_SESSION['error'] = "Email already exists.";
    } else {
        $salt = bin2hex(random_bytes(32));
        $hashed_password = hash_password($password, $salt);
        
        $stmt = $conn->prepare("INSERT INTO Guest (fullname, contact, address, email, password, salt, type) VALUES (?, ?, ?, ?, ?, ?, 3)");
        $stmt->bind_param("ssssss", $fullname, $contact, $address, $email, $hashed_password, $salt);
        
        if ($stmt->execute()) {
            $_SESSION['success'] = "Registration successful! Please login.";
            header("Location: login.php");
            exit();
        } else {
            $_SESSION['error'] = "Registration failed. Please try again.";
        }
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Register - Roti Sri Bakery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding-top: 50px;
        }
        .form-container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo img {
            max-width: 150px;
            margin-bottom: 15px;
        }
        .password-requirements {
            font-size: 0.8rem;
            color: #6c757d;
            margin-top: 5px;
        }
        .form-floating {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-container">
            <div class="logo">
                <h2>Roti Sri Bakery</h2>
                <p class="text-muted">Create your account</p>
            </div>
            
            <?php if (isset($_SESSION['error'])): ?>
                <div class="alert alert-danger alert-dismissible fade show">
                    <?php echo $_SESSION['error']; unset($_SESSION['error']); ?>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php endif; ?>

            <form method="POST" action="" class="needs-validation" novalidate>
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="fullname" name="fullname" 
                           placeholder="Full Name" required pattern="[A-Za-z\s]{2,}" 
                           title="Name should only contain letters and spaces">
                    <label for="fullname">Full Name</label>
                    <div class="invalid-feedback">Please enter your full name.</div>
                </div>
                
                <div class="form-floating mb-3">
                    <input type="tel" class="form-control" id="contact" name="contact" 
                           placeholder="Contact Number" required pattern="[0-9]{10,}" 
                           title="Please enter a valid phone number">
                    <label for="contact">Contact Number</label>
                    <div class="invalid-feedback">Please enter a valid contact number.</div>
                </div>
                
                <div class="form-floating mb-3">
                    <textarea class="form-control" id="address" name="address" 
                              placeholder="Address" style="height: 100px" required></textarea>
                    <label for="address">Address</label>
                    <div class="invalid-feedback">Please enter your address.</div>
                </div>
                
                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email" 
                           placeholder="Email" required>
                    <label for="email">Email address</label>
                    <div class="invalid-feedback">Please enter a valid email address.</div>
                </div>
                
                <div class="form-floating mb-3">
                    <input type="password" class="form-control" id="password" name="password" 
                           placeholder="Password" required 
                           pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}">
                    <label for="password">Password</label>
                    <div class="password-requirements">
                        Password must contain:
                        <ul>
                            <li>At least 8 characters</li>
                            <li>At least one uppercase letter</li>
                            <li>At least one lowercase letter</li>
                            <li>At least one number</li>
                        </ul>
                    </div>
                </div>
                
                <div class="form-floating mb-3">
                    <input type="password" class="form-control" id="confirm_password" name="confirm_password" 
                           placeholder="Confirm Password" required>
                    <label for="confirm_password">Confirm Password</label>
                    <div class="invalid-feedback">Passwords must match.</div>
                </div>
                
                <button type="submit" class="btn btn-primary w-100 py-2">Register</button>
            </form>
            
            <div class="text-center mt-3">
                <p>Already have an account? <a href="login.php">Login here</a></p>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms)
                .forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault()
                            event.stopPropagation()
                        }
                        
                        // Check if passwords match
                        var password = document.getElementById('password')
                        var confirm = document.getElementById('confirm_password')
                        if (password.value !== confirm.value) {
                            confirm.setCustomValidity('Passwords must match')
                            event.preventDefault()
                            event.stopPropagation()
                        } else {
                            confirm.setCustomValidity('')
                        }
                        
                        form.classList.add('was-validated')
                    }, false)
                })
        })()
    </script>
</body>
</html>