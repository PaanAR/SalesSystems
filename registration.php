<?php
require_once 'db_connection.php';

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate and process the form data
    $fullname = htmlspecialchars(trim($_POST['fullname']));
    $contact = htmlspecialchars(trim($_POST['contact']));
    $email = htmlspecialchars(trim($_POST['email']));
    $password = htmlspecialchars(trim($_POST['password']));
    $confirm_password = htmlspecialchars(trim($_POST['confirm_password']));
    $role = $_POST['role'];
    $employee_id = isset($_POST['employee_id']) ? htmlspecialchars(trim($_POST['employee_id'])) : null;

    // Check if passwords match
    if ($password !== $confirm_password) {
        $error = "Passwords do not match.";
    } else {
        // Determine the type based on the role
        $type = null;
        if ($role === 'Supervisor') {
            $type = 1; // Type 1 for Supervisor
        } elseif ($role === 'Clerk') {
            $type = 2; // Type 2 for Clerk
        } elseif ($role === 'Guest') {
            $type = 3; // Type 3 for Guest
        }

        // Check if Employee ID is valid for Supervisor and Clerk roles
        if (($role === 'Supervisor' || $role === 'Clerk') && empty($employee_id)) {
            $error = "Employee ID is required for Supervisor and Clerk roles.";
        } else {
            // Check if the Employee ID and Full Name match and are not assigned
            if ($role === 'Supervisor' || $role === 'Clerk') {
                $stmt = $conn->prepare("SELECT * FROM employee_ids WHERE employee_id = ? AND fullname = ? AND assigned = 0");
                $stmt->bind_param("ss", $employee_id, $fullname);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($result->num_rows === 0) {
                    $error = "Invalid Employee ID or Full Name, or the ID is already assigned.";
                }
            }

            // If no errors, proceed to insert into the database
            if (!isset($error)) {
                // Insert into the guest table
                $stmt = $conn->prepare("INSERT INTO guest (fullname, contact, email, password, type, employee_id) VALUES (?, ?, ?, ?, ?, ?)");
                $stmt->bind_param("ssssss", $fullname, $contact, $email, password_hash($password, PASSWORD_DEFAULT), $type, $employee_id);
                $stmt->execute();

                // Mark the Employee ID as assigned if applicable
                if ($role === 'Supervisor' || $role === 'Clerk') {
                    $stmt = $conn->prepare("UPDATE employee_ids SET assigned = 1 WHERE employee_id = ? AND fullname = ?");
                    $stmt->bind_param("ss", $employee_id, $fullname);
                    $stmt->execute();
                }

                // Redirect to login or success page after registration
                header("Location: login.php"); // Change as needed
                exit();
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .registration-container {
            max-width: 500px;
            margin: auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-label {
            font-weight: bold;
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>
    <script>
        function toggleEmployeeId() {
            const role = document.querySelector('select[name="role"]').value;
            const employeeIdField = document.getElementById('employee_id_field');
            employeeIdField.style.display = (role === 'Supervisor' || role === 'Clerk') ? 'block' : 'none';
        }
    </script>
</head>
<body>
    <div class="container mt-5">
        <div class="registration-container">
            <h2 class="text-center">Registration Form</h2>
            <form method="POST" action="">
                <div class="mb-3">
                    <label for="fullname" class="form-label">Full Name</label>
                    <input type="text" class="form-control" name="fullname" required>
                </div>
                <div class="mb-3">
                    <label for="contact" class="form-label">Contact Number</label>
                    <input type="text" class="form-control" name="contact" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" name="password" required>
                </div>
                <div class="mb-3">
                    <label for="confirm_password" class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" name="confirm_password" required>
                </div>
                <div class="mb-3">
                    <label for="role" class="form-label">Role</label>
                    <select class="form-select" name="role" onchange="toggleEmployeeId()" required>
                        <option value="">Select Role</option>
                        <option value="Supervisor">Supervisor</option>
                        <option value="Clerk">Clerk</option>
                        <option value="Guest">Guest</option>
                    </select>
                </div>
                <div class="mb-3" id="employee_id_field" style="display: none;">
                    <label for="employee_id" class="form-label">Employee ID</label>
                    <input type="text" class="form-control" name="employee_id" placeholder="Enter Employee ID">
                </div>
                <button type="submit" class="btn btn-primary w-100">Register</button>
            </form>
            <?php if (isset($error)): ?>
                <div class="alert alert-danger mt-3"><?php echo $error; ?></div>
            <?php endif; ?>
            <div class="mt-3">
                <p>Already have an account? <a href="login.php">Login here</a></p>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
