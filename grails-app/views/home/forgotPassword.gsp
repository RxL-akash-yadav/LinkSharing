<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Reset Request</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.15);
            margin-bottom: 25px;
        }
        .form-header {
            background-color: #555;
            color: white;
            font-weight: bold;
            padding: 15px 20px;
        }
        .form-body {
            padding: 20px;
            background-color: white;
        }
    </style>
</head>
<body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand navbar-dark m-4">
        <div class="container navbar-container">
            <g:link controller="user" action="dashboard" class="navbar-brand" style="color: blue">LinkSharing</g:link>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="form-card">
                    <div class="form-header">Forgot Password</div>
                    <div class="form-body">
                        <g:if test="${flash.error}">
                            <div class="alert alert-danger">
                                ${flash.error}
                            </div>
                        </g:if>
                        <g:if test="${flash.message}">
                            <div class="alert alert-success">
                                ${flash.message}
                            </div>
                        </g:if>

                        <p class="mb-3">Enter your email address below and we'll send you a link to reset your password.</p>

                        <g:form controller="home" action="forgotPassword" method="POST">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Send Reset Link</button>
                            </div>
                            <div class="mt-3 text-center">
                                <g:link controller="home" action="index">Back to Login</g:link>
                            </div>
                        </g:form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

