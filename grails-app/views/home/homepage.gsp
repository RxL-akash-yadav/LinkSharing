<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home Page</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
        }
        .navbar-container {
            z-index: 2;
            box-shadow: 0 5px 8px gray;
            background-color: #f8f9fa;
            color: black;
            border: 1px solid black;
            border-radius: 5px;
            height: 58px;
        }
        .container {
            z-index: 2;
            box-shadow: 0 5px 8px gray;
        }
        .profile-image {
            height: 100px;
            width: 100px;
            border-radius: 50%;
        }
        .form-control:focus {
            color: black;
            font-weight: bold;
            box-shadow: none;
            border-color: #000;
            border-width: 2px;
        }
        .dropdown-toggle::after {
            display: none;
        }
        
        /* New streamlined card styling */
        .content-card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.15);
            margin-bottom: 25px;
        }
        .content-header {
            background-color: #555;
            color: white;
            font-weight: bold;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .content-body {
            padding: 20px;
            background-color: white;
        }
        
        /* Post item styling */
        .post-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.2s;
        }
        .post-item:last-child {
            border-bottom: none;
        }
        .post-item:hover {
            background-color: #f9f9f9;
        }
        
        /* Reload button styling */
        .reload-btn {
            cursor: pointer;
            transition: transform 0.5s ease-in-out;
            color: #ddd;
        }
        .reload-btn:hover {
            color: white;
        }
        .reload-btn.spinning {
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .loading-spinner {
            display: inline-block;
            width: 2rem;
            height: 2rem;
            vertical-align: middle;
            border: 0.25em solid currentColor;
            border-right-color: transparent;
            border-radius: 50%;
            animation: spin 0.75s linear infinite;
        }
        
        /* Form styling */
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

            <!-- Search Form -->
            <g:form controller="user" action="search" class="d-flex me-3" method="GET">
                <div class="input-group">
                    <input class="form-control" type="search" name="q" placeholder="Search">
                    <button class="btn btn-dark" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </g:form>
        </div>
    </nav>
    
    <!-- Flash Messages -->
    <div class="container">
        <g:if test="${flash.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${flash.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </g:if>
        <g:if test="${flash.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${flash.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </g:if>
    </div>

    <!-- Main Container -->
    <div class="container mt-4 p-4" style="border:none; box-shadow: none;">
        <div class="row">
            <!-- Left Column - Posts -->
            <div class="col-md-7">
                <!-- Recent Shares Card -->
                <div class="content-card">
                    <div class="content-header">
                        <span>Recent Shares</span>
                        <i id="recentSharesReload" class="bi bi-arrow-clockwise reload-btn" title="Reload recent shares"></i>
                    </div>
                    <div class="content-body p-0" id="recentSharesContainer">
                        <div class="text-center py-4">
                            <div class="loading-spinner"></div>
                            <p class="mt-2">Loading recent shares...</p>
                        </div>
                    </div>
                </div>

                <!-- Top Posts Card -->
                <div class="content-card">
                    <div class="content-header">
                        <span>Top Posts</span>
                        <div class="d-flex align-items-center">
                            <i id="topPostsReload" class="bi bi-arrow-clockwise reload-btn me-3" title="Reload top posts"></i>
                            <select id="topPostFilter" class="form-select form-select-sm bg-dark text-white border-0">
                                <option value="today">Today</option>
                                <option value="week" selected>1 week</option>
                                <option value="month">1 month</option>
                                <option value="year">1 year</option>
                            </select>
                        </div>
                    </div>
                    <div class="content-body p-0" id="topPostsContainer">
                        <div class="text-center py-4">
                            <div class="loading-spinner"></div>
                            <p class="mt-2">Loading top posts...</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column - Forms -->
            <div class="col-md-5">
                <!-- Login Card -->
                <div class="form-card">
                    <div class="form-header">Login</div>
                    <div class="form-body">
                        <g:form controller="home" action="login" method="POST">
                            <div class="mb-3">
                                <label>Username</label>
                                <input type="text" name="username" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label>Password</label>
                                <input type="password" name="password" class="form-control">
                            </div>
                            <div class="mb-3">
                                <a href="${createLink(controller: 'home', action: 'forgotPassword')}">Forgot password</a>                            </div>
                            <button type="submit" class="btn btn-primary w-100">Login</button>
                        </g:form>
                    </div>
                </div>

                <!-- Register Card -->
                <div class="form-card">
                    <div class="form-header">Register</div>
                    <div class="form-body">
                        <g:form controller="home" action="register" method="POST">
                            <div class="mb-2">
                                <label>First name *</label>
                                <input type="text" name="firstName" class="form-control" required />
                            </div>
                            <div class="mb-2">
                                <label>Last name *</label>
                                <input type="text" name="lastName" class="form-control" required />
                            </div>
                            <div class="mb-2">
                                <label>Email *</label>
                                <input type="email" name="email" class="form-control" required />
                            </div>
                            <div class="mb-2">
                                <label>Username *</label>
                                <input type="text" name="username" class="form-control" required />
                            </div>
                            <div class="mb-2">
                                <label>Password *</label>
                                <input type="password" name="password" class="form-control" required />
                            </div>
                            <div class="mb-2">
                                <label>Confirm password *</label>
                                <input type="password" name="confirmPassword" class="form-control" required />
                            </div>
                            <div class="mb-3">
                                <label>Photo</label>
                                <input type="file" name="photo" class="form-control" />
                            </div>
                            <button type="submit" class="btn btn-success w-100">Register</button>
                        </g:form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <g:javascript library="jquery"/>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            fetchRecentShares();
            fetchTopPosts('week'); // Changed default filter to 'week'

            // Add reload button event listeners
            document.getElementById("recentSharesReload").addEventListener("click", function() {
                this.classList.add("spinning");
                fetchRecentShares();
            });

            document.getElementById("topPostsReload").addEventListener("click", function() {
                this.classList.add("spinning");
                fetchTopPosts(document.getElementById("topPostFilter").value);
            });

            document.getElementById("topPostFilter").addEventListener("change", function() {
                const reloadIcon = document.getElementById("topPostsReload");
                reloadIcon.classList.add("spinning");
                fetchTopPosts(this.value); // Fetch based on selected time range
            });
        });

        function fetchRecentShares() {
            document.getElementById('recentSharesContainer').innerHTML = `
                <div class="text-center py-4">
                    <div class="loading-spinner"></div>
                    <p class="mt-2">Loading recent shares...</p>
                </div>
            `;
            
            fetch('${createLink(controller: "home", action: "recentSharesAjax")}', {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) throw new Error("Network response was not ok");
                return response.text();
            })
            .then(html => {
                document.getElementById('recentSharesContainer').innerHTML = html;
                document.getElementById("recentSharesReload").classList.remove("spinning");
            })
            .catch(error => {
                document.getElementById('recentSharesContainer').innerHTML = '<div class="p-4 text-danger">Error loading recent shares. Please try again later.</div>';
                document.getElementById("recentSharesReload").classList.remove("spinning");
                console.error('Error fetching recent shares:', error);
            });
        }

        function fetchTopPosts(filter = 'week') { // Updated default parameter to 'week'
            document.getElementById('topPostsContainer').innerHTML = `
                <div class="text-center py-4">
                    <div class="loading-spinner"></div>
                    <p class="mt-2">Loading top posts...</p>
                </div>
            `;
            
            fetch('${createLink(controller: "home", action: "topPostAjax")}?filter=' + filter, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) throw new Error("Network response was not ok");
                return response.text();
            })
            .then(html => {
                document.getElementById('topPostsContainer').innerHTML = html;
                document.getElementById("topPostsReload").classList.remove("spinning");
            })
            .catch(error => {
                document.getElementById('topPostsContainer').innerHTML = '<div class="p-4 text-danger">Error loading top posts. Please try again later.</div>';
                document.getElementById("topPostsReload").classList.remove("spinning");
                console.error('Error fetching top posts:', error);
            });
        }
    </script>
</body>
</html>