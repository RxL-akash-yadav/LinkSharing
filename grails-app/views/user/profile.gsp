<%@ page import="com.example.Subscription" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile - Link Sharing</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
        }
        .profile-image {
            height: 100px;
            width: 100px;
            border-radius: 50%;
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
    <input type="hidden" id="currentUserId" value="${user.id}" />

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand navbar-dark m-4">
        <div class="container navbar-container">
            <g:link controller="user" action="dashboard" class="navbar-brand" style="color: blue">LinkSharing</g:link>

            <div class="d-flex align-items-center ms-auto">
                <!-- Action Buttons -->
                <div class="d-flex align-items-center me-3">

                </div>

                <!-- Search Form -->
                <g:form controller="user" action="search" class="d-flex me-3" method="GET">
                    <div class="input-group">
                        <input class="form-control" type="search" name="q" placeholder="Search">
                        <button class="btn btn-dark" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </g:form>

                <!-- User Profile Dropdown -->
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
                            <g:if test="${session.user && session.user.admin}">
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

    <!-- Main Container -->
    <div class="container mt-4 p-4" style="border:none; box-shadow: none;">
        <div class="row">
            <div class="col-md-4 mb-4">
                <!-- User Profile Card -->
                <div class="content-card">
                    <div class="content-header">
                        <span>Profile</span>
                    </div>
                    <div class="content-body">
                        <div class="d-flex align-items-center mb-3">
                            <a href="${createLink(controller: 'user', action: 'profile', id: user.id)}">
                                <img src="${createLink(controller: 'user', action: 'photo', id: user.id)}"
                                     onerror="this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                                     class="profile-image me-3" alt="Profile" width="30">
                            </a>
                            <div>
                                <h5 class="mb-1">${user.firstName} ${user.lastName}</h5>
                                <a href="${createLink(controller: 'user', action: 'profile', id: user.id)}">
                                    <p class="text-muted mb-0">@${user.username}</p>
                                </a>
                            </div>
                        </div>
                        <div class="row text-center">
                            <div class="col-6">
                                <p class="mb-0"><strong>Subscriptions</strong></p>
                                <a href="${createLink(controller: 'user', action: 'profile', id: user.id)}">
                                    <p>${subCount}</p>
                                </a>
                            </div>
                            <div class="col-6">
                                <p class="mb-0"><strong>Topics</strong></p>
                                <a href="${createLink(controller: 'user', action: 'profile', id: user.id)}">
                                    <p>${topicCount}</p>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Topics Card with Reload Button -->
                <div class="content-card">
                    <div class="content-header">
                        <span>Topics</span>
                        <div class="d-flex align-items-center">
                            <i id="topicsReload" class="bi bi-arrow-clockwise reload-btn me-3" title="Reload topics"></i>
                            <form id="topicSearchForm" onsubmit="event.preventDefault(); loadTopics(0);" class="d-flex" style="max-width: 250px;">
                                <div class="input-group input-group-sm">
                                    <input type="text" id="topicSearchInput" name="search" class="form-control form-control-sm"
                                           placeholder="Search" value="${params.search ?: ''}">
                                    <button type="submit" class="btn btn-dark btn-sm">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="content-body p-0" id="topicSection">
                        <div class="text-center py-4">
                            <div class="loading-spinner"></div>
                            <p class="mt-2">Loading topics...</p>
                        </div>
                    </div>
                </div>

                <!-- Subscriptions Card with Reload Button -->
                <div class="content-card">
                    <div class="content-header">
                        <span>Subscriptions</span>
                        <div class="d-flex align-items-center">
                            <i id="subscriptionsReload" class="bi bi-arrow-clockwise reload-btn me-3" title="Reload subscriptions"></i>
                            <form id="subscriptionSearchForm" onsubmit="event.preventDefault(); loadSubscriptions(0);" class="d-flex" style="max-width: 250px;">
                                <div class="input-group input-group-sm">
                                    <input type="text" id="subscriptionSearchInput" name="search" class="form-control form-control-sm"
                                           placeholder="Search" value="${params.search ?: ''}">
                                    <button type="submit" class="btn btn-dark btn-sm">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="content-body p-0" id="subscriptionSection">
                        <div class="text-center py-4">
                            <div class="loading-spinner"></div>
                            <p class="mt-2">Loading subscriptions...</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-8">
                <!-- Posts Card -->
                <div class="content-card">
                    <div class="content-header">
                        <span>Posts</span>
                        <div class="d-flex align-items-center">
                            <i id="postsReload" class="bi bi-arrow-clockwise reload-btn me-3" title="Reload posts"></i>
                            <form id="postSearchForm" onsubmit="event.preventDefault(); loadPosts(0);" class="d-flex" style="max-width: 250px;">
                                <div class="input-group input-group-sm">
                                    <input type="text" id="postSearchInput" name="search" class="form-control form-control-sm"
                                           placeholder="Search" value="${params.search ?: ''}">
                                    <button type="submit" class="btn btn-dark btn-sm">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="content-body p-0" id="postSection">
                        <div class="text-center py-4">
                            <div class="loading-spinner"></div>
                            <p class="mt-2">Loading posts...</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Invitation Modal -->
    <div class="modal fade" id="invitationModal" tabindex="-1" aria-labelledby="invitationModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 shadow">
                <div class="modal-header">
                    <h5 class="modal-title" id="invitationModalLabel">Send Invitation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <g:form controller="topic" action="send" method="POST" id="invitationForm">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="inviteEmail" class="form-label">Email address</label>
                            <input type="email" class="form-control" id="inviteEmail" name="email" placeholder="Enter email" required>
                        </div>

                        <div class="mb-3">
                            <label for="topicSelectDisplay" class="form-label">Topic</label>
                            <!-- Use a disabled input to show topic name instead of dropdown -->
                            <input type="text" id="topicSelectDisplay" class="form-control" disabled>
                            <input type="hidden" name="topicId" id="topicId" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill">Send</button>
                    </div>
                </g:form>
            </div>
        </div>
    </div>

    <script>
        // Declare this early so it's globally available
        let currentUserId = '${user.id}';

        document.addEventListener("DOMContentLoaded", function () {
            if (!currentUserId) {
                console.error('User ID is not available. Aborting preload.');
                return;
            }

            // Load data for all sections when DOM is ready
            loadTopics();
            loadSubscriptions();
            loadPosts();

            // Add reload button event listeners
            document.getElementById("topicsReload").addEventListener("click", function() {
                this.classList.add("spinning");
                loadTopics();
            });

            document.getElementById("subscriptionsReload").addEventListener("click", function() {
                this.classList.add("spinning");
                loadSubscriptions();
            });

            document.getElementById("postsReload").addEventListener("click", function() {
                this.classList.add("spinning");
                loadPosts();
            });
        });

        const invitationModal = document.getElementById('invitationModal');
        invitationModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const topicId = button.getAttribute('data-topic-id');
            const topicName = button.getAttribute('data-topic-name');

            invitationModal.querySelector('#topicId').value = topicId;
            // Set the topic name in the disabled input
            invitationModal.querySelector('#topicSelectDisplay').value = topicName;
        });

        function loadTopics(offset = 0) {
            const search = document.getElementById("topicSearchInput")?.value || "";
            const encodedSearch = encodeURIComponent(search);
            const url = '/user/loadTopicsAjax?userId=' + currentUserId + '&offset=' + offset + '&max=5&search=' + encodedSearch;

            fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                .then(response => {
                    if (!response.ok) throw new Error("Failed to load topics");
                    return response.text();
                })
                .then(html => {
                    document.getElementById("topicSection").innerHTML = html;
                    document.getElementById("topicsReload")?.classList.remove("spinning");
                })
                .catch(error => {
                    console.error("Error loading topics:", error);
                    document.getElementById("topicSection").innerHTML = '<div class="p-4 text-danger">Error loading topics. Please try again later.</div>';
                    document.getElementById("topicsReload")?.classList.remove("spinning");
                });
        }

        function loadSubscriptions(offset = 0) {
            const search = document.getElementById("subscriptionSearchInput")?.value.trim() || "";
            const encodedSearch = encodeURIComponent(search);
            const url = '/user/loadSubscriptionsAjax?userId=' + currentUserId + '&offset=' + offset + '&max=5&search=' + encodedSearch;

            fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                .then(response => {
                    if (!response.ok) throw new Error("Failed to load subscriptions");
                    return response.text();
                })
                .then(html => {
                    document.getElementById("subscriptionSection").innerHTML = html;
                    document.getElementById("subscriptionsReload")?.classList.remove("spinning");
                })
                .catch(error => {
                    console.error("Error loading subscriptions:", error);
                    document.getElementById("subscriptionSection").innerHTML = '<div class="p-4 text-danger">Error loading subscriptions. Please try again later.</div>';
                    document.getElementById("subscriptionsReload")?.classList.remove("spinning");
                });
        }

        function loadPosts(offset = 0) {
            const search = document.getElementById("postSearchInput")?.value.trim() || "";
            const encodedSearch = encodeURIComponent(search);
            const url = '/user/loadPostsAjax?userId=' + currentUserId + '&offset=' + offset + '&max=5&search=' + encodedSearch;

            fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                .then(response => {
                    if (!response.ok) throw new Error("Failed to load posts");
                    return response.text();
                })
                .then(html => {
                    document.getElementById("postSection").innerHTML = html;
                    document.getElementById("postsReload")?.classList.remove("spinning");
                })
                .catch(error => {
                    console.error("Error loading posts:", error);
                    document.getElementById("postSection").innerHTML = '<div class="p-4 text-danger">Error loading posts. Please try again later.</div>';
                    document.getElementById("postsReload")?.classList.remove("spinning");
                });
        }
        
        // AJAX subscribe function
        function ajaxSubscribe(topicId, btn) {
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Subscribing...';
            
            fetch('${createLink(controller: 'user', action: 'ajaxSubscribe')}?topicId=' + topicId, {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Update button appearance
                    btn.classList.remove('btn-outline-success');
                    btn.classList.add('btn-outline-danger');
                    btn.textContent = 'Unsubscribe';
                    btn.classList.remove('subscribe-btn');
                    btn.classList.add('unsubscribe-btn');
                    
                    // Show success notification
                    showNotification('Successfully subscribed', 'success');
                    
                    // Reload sections to reflect changes
                    loadSubscriptions();
                    loadTopics();
                } else {
                    // Show error and reset button
                    showNotification(data.message || 'Failed to subscribe', 'danger');
                    btn.textContent = 'Subscribe';
                }
            })
            .catch(error => {
                console.error('Error subscribing:', error);
                showNotification('Error: Could not connect to server', 'danger');
                btn.textContent = 'Subscribe';
            })
            .finally(() => {
                btn.disabled = false;
            });
        }
        
        // AJAX unsubscribe function
        function ajaxUnsubscribe(topicId, btn) {
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Unsubscribing...';
            
            fetch('${createLink(controller: 'user', action: 'ajaxUnsubscribe')}?topicId=' + topicId, {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Update button appearance
                    btn.classList.remove('btn-outline-danger');
                    btn.classList.add('btn-outline-success');
                    btn.textContent = 'Subscribe';
                    btn.classList.remove('unsubscribe-btn');
                    btn.classList.add('subscribe-btn');
                    
                    // Show success notification
                    showNotification('Successfully unsubscribed', 'success');
                    
                    // Reload sections to reflect changes
                    loadSubscriptions();
                    loadTopics();
                } else {
                    // Show error and reset button
                    showNotification(data.message || 'Failed to unsubscribe', 'danger');
                    btn.textContent = 'Unsubscribe';
                }
            })
            .catch(error => {
                console.error('Error unsubscribing:', error);
                showNotification('Error: Could not connect to server', 'danger');
                btn.textContent = 'Unsubscribe';
            })
            .finally(() => {
                btn.disabled = false;
            });
        }
        
        // Function to show toast notifications
        function showNotification(message, type = 'success') {
            // Create notification element
            const notificationDiv = document.createElement('div');
            notificationDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed top-0 end-0 m-3`;
            notificationDiv.style.zIndex = "9999";
            notificationDiv.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            `;
            
            // Append to body
            document.body.appendChild(notificationDiv);
            
            // Auto-dismiss after 5 seconds
            setTimeout(() => {
                notificationDiv.classList.remove('show');
                setTimeout(() => notificationDiv.remove(), 150);
            }, 5000);
        }
    </script>
</body>
</html>
