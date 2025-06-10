<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - Link Sharing</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .navbar-container {
            z-index: 2;
            box-shadow: 0 5px 8px gray;
            background-color: #f8f9fa;
            color: black;
            border: 1px solid black;
            border-radius: 5px;
        }
        body {
            background-color: #ffffff;
            background-size: 20px 20px;
            background-position: center center;
        }
        .container {
            background-color: transparent;
            z-index: 2;
            box-shadow: 0 5px 8px gray;
        }
        .content-card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.15);
            margin-bottom: 25px;
            border: 1px solid #dee2e6;
            background-color: rgba(255, 255, 255, 0.95);
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
        .profile-image {
            width: 100px;
            height: 100px;
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
        .list-group-item {
            background-color: rgba(255, 255, 255, 0.9);
        }
        .search-container {
            position: relative;
        }
        .search-container .form-control {
            padding-right: 35px;
            background-color: rgba(255, 255, 255, 0.9);
        }
        .search-container .search-icon {
            position: absolute;
            right: 10px;
            top: 8px;
        }
        .topic-image {
            width: 50px;
            height: 50px;
        }
        .btn-primary {
            background-color: #0d6efd;
        }
        .btn-outline-secondary {
            border-color: #6c757d;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand navbar-dark m-4">
    <div class="container navbar-container">
        <g:link controller="user" action="dashboard" class="navbar-brand" style="color: blue">LinkSharing</g:link>
        <div class="d-flex align-items-center ms-auto">
            <g:form controller="user" action="search" class="d-flex me-3" method="GET">
                <div class="input-group">
                    <input class="form-control" type="search" name="q" placeholder="Search">
                    <button class="btn btn-dark" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </g:form>
            <div class="d-flex align-items-center">
                <span class="p-3 text-dark">${session.user?.firstName}</span>
                <div class="dropdown">
                    <a class="nav-link dropdown-toggle p-2" href="#" data-bs-toggle="dropdown">
                        <img src="${createLink(controller: 'user', action: 'photo', id: session.user?.id)}"
                             onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                             alt="User Profile" class="rounded-circle" width="30">
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><g:link class="dropdown-item" controller="user" action="editprofile">Profile</g:link></li>
                        <g:if test="${session.user.admin}">
                            <li><g:link class="dropdown-item" controller="admin" action="users">Users</g:link></li>
                            <li><g:link class="dropdown-item" controller="resource" action="allTopics">Topics</g:link></li>
                            <li><g:link class="dropdown-item" controller="resource" action="allResource">Posts</g:link></li>
                        </g:if>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <form method="post" action="${createLink(controller: 'home', action: 'logout')}">
                                <button type="submit" class="dropdown-item">Logout</button>
                            </form>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
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

<div class="container py-4">
    <h4 class="mb-4">Edit Profile</h4>
    <div class="row">
        <!-- Left Column - User Info and Topics -->
        <div class="col-md-5">
            <!-- User Info Card -->
            <div class="content-card mb-4">
                <div class="content-header">
                    <span>User Info</span>
                </div>
                <div class="content-body">
                    <div class="d-flex align-items-center mb-3">
                        <a href="${createLink(controller: 'user', action: 'profile', id: session.user.id)}">
                            <img src="${createLink(controller: 'user', action: 'photo', id: session.user.id)}"
                                 onerror="this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                                 class="profile-image me-3" alt="Profile" width="30">
                        </a>
                        <div>
                            <h5 class="mb-1">
                                <a href="${createLink(controller: 'user', action: 'profile', id: session.user.id)}" class="text-decoration-none text-dark">
                                    ${user.firstName} ${user.lastName}
                                </a>
                            </h5>
                            <a href="${createLink(controller: 'user', action: 'profile', id: session.user.id)}" class="text-muted mb-0 text-decoration-none">
                                @${user.username}
                            </a>
                        </div>
                    </div>
                    <div class="row text-center">
                        <div class="col-6">
                            <p class="mb-0"><strong>
                                <g:link controller="user" action="mySubscriptions" class="text-decoration-none text-dark">
                                    Subscriptions
                                </g:link>
                            </strong></p>
                            <p>
                                <g:link controller="user" action="mySubscriptions" class="text-decoration-none text-dark">
                                    ${subscriptionCount}
                                </g:link>
                            </p>
                        </div>
                        <div class="col-6">
                            <p class="mb-0"><strong>
                                <g:link controller="user" action="myTopics" class="text-decoration-none text-dark">
                                    Topics
                                </g:link>
                            </strong></p>
                            <p>
                                <g:link controller="user" action="myTopics" class="text-decoration-none text-dark">
                                    ${topicCount}
                                </g:link>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Topics Management Card -->
            <div class="content-card mb-3">
                <div class="content-header">
                    <span>Topics</span>
                    <form onsubmit="event.preventDefault(); searchTopic();" class="d-flex" style="max-width: 250px;">
                        <div class="input-group input-group-sm w-100">
                            <input type="text" id="topicSearch" class="form-control" placeholder="Search">
                            <button type="submit" class="btn btn-dark">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </form>
                </div>
                <div class="content-body">
                    <div id="topic-section">
                        <g:render template="/user/editTopic" model="[topics: topics]" />
                    </div>
                </div>
            </div>
        </div>
        <!-- Right Column - Profile Edit Forms -->
        <div class="col-md-7">
            <!-- Profile Edit Form -->
            <div class="content-card mb-4">
                <div class="content-header">
                    <span>Profile</span>
                </div>
                <div class="content-body">
                    <g:form controller="user" action="updateProfile" method="POST" enctype="multipart/form-data">
                        <div class="mb-3 row">
                            <label for="firstName" class="col-sm-3 col-form-label">First name *</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="firstName" name="firstName" value="${user.firstName}" required>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="lastName" class="col-sm-3 col-form-label">Last name *</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="lastName" name="lastName" value="${user.lastName}" required>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="username" class="col-sm-3 col-form-label">Username *</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="username" name="username" value="${user.username}" required>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="photo" class="col-sm-3 col-form-label">Photo</label>
                            <div class="col-sm-9">
                                <div class="input-group">
                                    <input type="file" class="form-control" id="photo" name="photo" value="${user.photo}">
                                    <button class="btn btn-outline-secondary" type="button">Browse</button>
                                </div>
                            </div>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-secondary">Update</button>
                        </div>
                    </g:form>
                </div>
            </div>
            <!-- Password Change Form -->
            <div class="content-card">
                <div class="content-header">
                    <span>Change password</span>
                </div>
                <div class="content-body">
                    <g:form controller="user" action="updatePassword" method="POST">
                        <div class="mb-3 row">
                            <label for="password" class="col-sm-3 col-form-label">Password *</label>
                            <div class="col-sm-9">
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="confirmPassword" class="col-sm-3 col-form-label">Confirm password *</label>
                            <div class="col-sm-9">
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-secondary">Update</button>
                        </div>
                    </g:form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function refreshSection(url, containerId) {
        fetch(url)
            .then(res => res.text())
            .then(html => document.getElementById(containerId).innerHTML = html);
    }

    function searchTopic() {
        const query = document.getElementById("topicSearch").value.trim();
        const encodedQuery = encodeURIComponent(query);
        refreshSection('/user/editTopic?search=' + encodedQuery, 'topic-section');
    }

    function debounce(func, delay) {
        let timeout;
        return function (...args) {
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(this, args), delay);
        };
    }
    const debouncedSearch = debounce(searchTopic, 300);
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
