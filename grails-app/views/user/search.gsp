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
    .navbar-container {
        z-index: 2;
        box-shadow: 0 5px 8px gray;
        background-color: #f8f9fa;
        color: black;
        border: 1px solid black;
        border-radius: 5px;
    }
    .container{
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
    .profile-image {
        height: 100px;
        width: 100px;
        border-radius: 50%;
    }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand navbar-dark m-4">
    <div class="container navbar-container">
        <g:link controller="user" action="dashboard" class="navbar-brand" style="color: blue">LinkSharing</g:link>
        <div class="d-flex align-items-center ms-auto">
            <!-- Action Buttons -->
            <div class="d-flex align-items-center me-3">
                <button type="button" class="btn btn-link p-0 me-3" data-bs-toggle="modal" data-bs-target="#shareLinkModal">
                    <i class="bi bi-link-45deg fs-4 text-dark"></i>
                </button>
                <button type="button" class="btn btn-link p-0 me-3" data-bs-toggle="modal" data-bs-target="#shareDocumentModal">
                    <i class="bi bi-file-earmark-fill fs-4 text-dark"></i>
                </button>
            </div>
            <!-- Search Form -->
            <g:form controller="user" action="search" class="d-flex me-3" method="GET">
                <div class="input-group">
                    <input class="form-control" type="search" name="q" placeholder="Search" value="${q}">
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
    <div class="row">
        <!-- Trending Topics Card -->
        <div class="col-md-5 mb-4">
            <div class="content-card mb-4">
                <div class="content-header">Trending Topics</div>
                <div class="content-body p-0">
                    <g:each in="${trendingTopics}" var="topic">
                        <div class="post-item">
                            <div class="d-flex gap-3">
                                <a href="${createLink(controller: 'user', action: 'profile', id: topic.createdBy.id)}" class="flex-shrink-0">
                                    <img src="${createLink(controller: 'user', action: 'photo', id: topic.createdBy.id)}"
                                         onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                                         class="rounded-circle" width="70" height="70" style="object-fit: cover;" />
                                </a>
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <strong>${topic.createdBy.firstName} ${topic.createdBy.lastName}</strong>
                                        <a href="${createLink(controller: 'resource', action: 'topic', id: topic.id)}" class="text-decoration-none badge bg-light text-dark">
                                            ${topic.name}
                                        </a>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                                        <a href="${createLink(controller: 'user', action: 'profile', id: topic.createdBy.id)}" class="text-decoration-none text-muted">
                                            @${topic.createdBy.username}
                                        </a>
                                        <span>
                                            <span class="badge bg-light text-dark me-2">Subscriptions: ${topic.subscriptionCount}</span>
                                            <span class="badge bg-light text-dark">Posts: ${topic.postCount}</span>
                                        </span>
                                    </div>
                                    <div class="d-flex justify-content-between mt-2">
                                        <div>
                                            <g:if test="${Subscription.findByUserAndTopic(session.user, topic)}">
                                                <button class="btn btn-sm btn-outline-danger subscribe-btn" data-topic-id="${topic.id}">
                                                    Unsubscribe
                                                </button>
                                            </g:if>
                                            <g:else>
                                                <button class="btn btn-sm btn-outline-primary subscribe-btn" data-topic-id="${topic.id}">
                                                    Subscribe
                                                </button>
                                            </g:else>
                                        </div>
                                        
                                    </div>
                                </div>
                            </div>
                        </div>
                    </g:each>
                </div>
            </div>
            <!-- Top Posts Card -->
            <div class="content-card">
                <div class="content-header d-flex justify-content-between align-items-center">
                    <span>Top Posts</span>
                </div>
                <div class="content-body p-0">
                    <g:each in="${topPosts}" var="resource">
                        <div class="post-item">
                            <div class="d-flex gap-3">
                                <a href="${createLink(controller: 'user', action: 'profile', id: resource.createdBy.id)}" class="flex-shrink-0">
                                    <img src="${createLink(controller: 'user', action: 'photo', id: resource.createdBy.id)}"
                                         onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                                         class="rounded-circle" width="70" height="70" style="object-fit: cover;" />
                                </a>
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <strong>${resource.createdBy.firstName} ${resource.createdBy.lastName}</strong>
                                        <a href="${createLink(controller: 'resource', action: 'topic', id: resource.topic.id)}" class="text-decoration-none badge bg-light text-dark">
                                            ${resource.topic.name}
                                        </a>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                                        <span>@${resource.createdBy.username}</span>
                                        <g:formatDate date="${resource.dateCreated}" format="dd MMM yyyy, hh:mm a"/>
                                    </div>
                                    <p class="mb-2">${resource.description}</p>
                                    <div class="d-flex justify-content-between mt-2">
                                        <div>
                                            <a href="https://twitter.com/intent/tweet?text=${resource.description?.encodeAsURL()}&url=${createLink(controller: 'resource', action: 'post', id: resource.id, absolute: true)}"
                                               class="btn btn-sm btn-outline-primary me-1" target="_blank" rel="noopener">
                                                <i class="fab fa-twitter"></i> Tweet
                                            </a>
                                            <a href="https://www.facebook.com/sharer/sharer.php?u=${createLink(controller: 'resource', action: 'post', id: resource.id, absolute: true)}"
                                               class="btn btn-sm btn-outline-primary" target="_blank" rel="noopener">
                                                <i class="fab fa-facebook"></i> Share
                                            </a>
                                        </div>
                                        <div>
                                            <g:if test="${resource instanceof com.example.DocumentResource}">
                                                <a href="/resource/download/${resource.id}" class="btn btn-outline-success btn-sm me-2">Download</a>
                                            </g:if>
                                            <g:elseif test="${resource instanceof com.example.LinkResource}">
                                                <a href="${resource.url}" class="btn btn-outline-success btn-sm me-2" target="_blank">View full site</a>
                                            </g:elseif>
                                            <g:link controller="resource" action="post" id="${resource.id}" class="btn btn-outline-primary btn-sm">View post</g:link>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </g:each>
                </div>
            </div>
        </div>
        <!-- Search Results Card -->
        <div class="col-md-7">
            <div class="content-card">
                <div class="content-header d-flex justify-content-between align-items-center mt-1">
                    <h6 class="mb-0">Search for "${q}"</h6>
                </div>
                <div class="content-body p-0" id="search-results-container">
                    <div class="text-center py-4" id="search-loading">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mt-2">Loading results...</p>
                    </div>
                </div>
                
                <!-- Pagination Controls -->
                <div class="d-flex justify-content-end p-3" id="search-pagination">
                    <!-- Pagination will be loaded here -->
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Share Link Modal -->
<div class="modal fade" id="shareLinkModal" tabindex="-1" aria-labelledby="shareLinkModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content rounded-4 shadow">
            <div class="modal-header">
                <h5 class="modal-title" id="shareLinkModalLabel">Share Link</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <g:form controller="resource" action="shareLink" method="POST" id="shareLinkForm">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="linkUrl" class="form-label">Link URL</label>
                        <input type="url" class="form-control" id="linkUrl" name="link" placeholder="Enter URL" required>
                    </div>
                    <div class="mb-3">
                        <label for="linkDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="linkDescription" name="description" rows="3" placeholder="Enter description" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="topicSelectShare" class="form-label">Select Topic</label>
                        <select id="topicSelectShare" name="topicId" class="form-select" required>
                            <option value="" disabled selected>Select a topic</option>
                            <g:each in="${topics}" var="topic">
                                <option value="${topic.id}">${topic.name}</option>
                            </g:each>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill">Share</button>
                </div>
            </g:form>
        </div>
    </div>
</div>

<!-- Share Document Modal -->
<div class="modal fade" id="shareDocumentModal" tabindex="-1" aria-labelledby="shareDocumentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content rounded-4 shadow">
            <div class="modal-header">
                <h5 class="modal-title" id="shareDocumentModalLabel">Share Document</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <g:form controller="resource" action="shareDocument" method="POST" enctype="multipart/form-data" id="shareDocumentForm">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="documentFile" class="form-label">Upload Document</label>
                        <input type="file" class="form-control" id="documentFile" name="filepath" accept=".pdf,.doc,.docx,.txt" required>
                    </div>
                    <div class="mb-3">
                        <label for="docDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="docDescription" name="description" rows="3" placeholder="Enter description"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="topicSelectDoc" class="form-label">Select Topic</label>
                        <select id="topicSelectDoc" name="topicId" class="form-select" required>
                            <option value="" disabled selected>Select a topic</option>
                            <g:each in="${topics}" var="topic">
                                <option value="${topic.id}">${topic.name}</option>
                            </g:each>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill">Share</button>
                </div>
            </g:form>
        </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Load initial search results when page loads
        loadSearchResults(0);
        
        // Set up event listeners for subscribe/unsubscribe buttons
        document.body.addEventListener('click', function(e) {
            const btn = e.target.closest('.subscribe-btn');
            if (!btn) return;
            
            e.preventDefault();
            const topicId = btn.getAttribute('data-topic-id');
            if (btn.textContent.trim() === 'Subscribe') {
                ajaxSubscribe(topicId, btn);
            } else if (btn.textContent.trim() === 'Unsubscribe') {
                ajaxUnsubscribe(topicId, btn);
            }
        });
    });
    
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
                btn.classList.remove('btn-outline-primary');
                btn.classList.add('btn-outline-danger');
                btn.textContent = 'Unsubscribe';
                
                // Show success notification
                showNotification(data.message || 'Successfully subscribed', 'success');
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
                btn.classList.add('btn-outline-primary');
                btn.textContent = 'Subscribe';
                
                // Show success notification
                showNotification(data.message || 'Successfully unsubscribed', 'success');
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
    
    // Function to load search results with pagination
    function loadSearchResults(offset) {
        const searchTerm = "${q}";
        const container = document.getElementById('search-results-container');
        const loadingIndicator = document.getElementById('search-loading');
        
        // Show loading indicator
        if (loadingIndicator) {
            loadingIndicator.style.display = 'block';
        }
        
        // AJAX call to load search results
        fetch('${createLink(controller: 'user', action: 'searchAjax')}?q=' + encodeURIComponent(searchTerm) + '&offset=' + offset, {
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => response.text())
        .then(html => {
            // Hide loading indicator
            if (loadingIndicator) {
                loadingIndicator.style.display = 'none';
            }
            
            // Update container with results
            container.innerHTML = html;
            
            // Update pagination controls
            fetch('${createLink(controller: 'user', action: 'searchPagination')}?q=' + encodeURIComponent(searchTerm) + '&offset=' + offset, {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.text())
            .then(paginationHtml => {
                document.getElementById('search-pagination').innerHTML = paginationHtml;
            });
        })
        .catch(error => {
            console.error('Error loading search results:', error);
            container.innerHTML = '<div class="alert alert-danger m-3">Failed to load search results. Please try again.</div>';
        });
    }
</script>
</body>
</html>
