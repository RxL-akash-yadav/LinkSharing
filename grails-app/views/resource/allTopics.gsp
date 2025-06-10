<%@ page import="com.example.Subscription" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Topics</title>
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

        /* Table styling */
        .table-container {
            overflow-x: auto;
        }
        .table {
            margin-bottom: 0;
        }
        .table th {
            background-color: #f8f9fa;
        }

        /* Sort buttons */
        .sort-link {
            color: #333;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
        .sort-link:hover {
            color: #000;
            text-decoration: underline;
        }

        /* Pagination styling */
        .pagination {
            margin-top: 1rem;
            margin-bottom: 0;
        }

        /* Subscribe button styling */
        .subscribe-toggle {
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .subscribe-toggle:hover {
            text-decoration: underline !important;
        }
        .subscribe-toggle.opacity-50 {
            cursor: not-allowed;
        }
    </style>
</head>
<body class="p-4">
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand navbar-dark m-4">
        <div class="container navbar-container">
            <g:link controller="user" action="dashboard" class="navbar-brand" style="color: blue">LinkSharing</g:link>

            <div class="d-flex align-items-center ms-auto">


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

    <!-- Main Container -->
    <div class="container mt-4 p-4" style="border:none; box-shadow: none;">
        <div class="row">
            <div class="col-12">
                <!-- Topics Management Card -->
                <div class="content-card">
                    <div class="content-header">
                        <span>Topics Management</span>
                        <div class="d-flex align-items-center ms-auto">
                            <g:form controller="resource" action="allTopics" method="get" class="d-flex align-items-center gap-3 mb-0">
                                <div class="d-flex align-items-center">
                                    <label class="me-2 mb-0">Visibility:</label>
                                    <select name="visibility" class="form-select form-select-sm" style="width: 120px;" onchange="this.form.submit()">
                                        <option value="" ${!params.visibility ? 'selected' : ''}>All Topics</option>
                                        <option value="PUBLIC" ${params.visibility == 'PUBLIC' ? 'selected' : ''}>PUBLIC</option>
                                        <option value="PRIVATE" ${params.visibility == 'PRIVATE' ? 'selected' : ''}>PRIVATE</option>
                                    </select>
                                </div>
                                <div class="d-flex gap-2" style="max-width: 300px;">
                                    <input type="search" name="search" class="form-control form-control-sm"
                                           placeholder="Topic name" value="${params.search ?: ''}">
                                    <button type="submit" class="btn btn-dark btn-sm">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                                <input type="hidden" name="sort" value="${params.sort ?: 'id'}" />
                                <input type="hidden" name="order" value="${params.order ?: 'asc'}" />
                                <input type="hidden" name="max" value="${params.max ?: 10}" />
                                <input type="hidden" name="offset" value="0" />
                            </g:form>
                        </div>
                    </div>
                    <div class="content-body p-0">
                        <!-- Table -->
                        <div class="table-container">
                            <table class="table table-striped mb-0">
                                <thead>
                                    <tr>
                                        <th>
                                            <g:link controller="resource" action="allTopics"
                                                    params="[sort: 'id', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Id ${params.sort == 'id' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>
                                            <g:link controller="resource" action="allTopics"
                                                    params="[sort: 'name', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Name ${params.sort == 'name' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>
                                            <g:link controller="resource" action="allTopics"
                                                    params="[sort: 'createdBy', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Created By ${params.sort == 'createdBy' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>
                                            <g:link controller="resource" action="allTopics"
                                                    params="[sort: 'dateCreated', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Date Created ${params.sort == 'dateCreated' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>
                                            <g:link controller="resource" action="allTopics"
                                                    params="[sort: 'lastUpdated', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Last Updated ${params.sort == 'lastUpdated' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>
                                            <g:link controller="resource" action="allTopics"
                                                    params="[sort: 'visibility', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Visibility ${params.sort == 'visibility' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>Subscriptions</th>
                                        <th>Posts</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <g:each in="${topics}" var="topic">
                                        <tr>
                                            <td>${topic.id}</td>
                                            <td>${topic.name}</td>
                                            <td>${topic.createdBy.username}</td>
                                            <td><g:formatDate date="${topic.dateCreated}" format="dd MMM yyyy, hh:mm a" /></td>
                                            <td><g:formatDate date="${topic.lastUpdated}" format="dd MMM yyyy, hh:mm a" /></td>
                                            <td>
                                                <span class="badge ${topic.visibility == 'PUBLIC' ? 'bg-success' : 'bg-secondary'}">
                                                    ${topic.visibility}
                                                </span>
                                            </td>
                                            <td class="subscription-count-${topic.id}">${topic.subscriptionCount}</td>
                                            <td>${topic.postCount}</td>
                                            <td>
                                                <g:if test="${Subscription.findByUserAndTopic(session.user, topic)}">
                                                    <button class="btn btn-sm btn-outline-danger subscribe-btn" 
                                                            data-topic-id="${topic.id}">
                                                        Unsubscribe
                                                    </button>
                                                </g:if>
                                                <g:else>
                                                    <button class="btn btn-sm btn-outline-primary subscribe-btn" 
                                                            data-topic-id="${topic.id}">
                                                        Subscribe
                                                    </button>
                                                </g:else>
                                            </td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="p-3 bg-light border-top">
                            <%
                                int currentPage = (offset / max) + 1
                                int totalPages = Math.ceil(totalTopics / max) as int
                            %>
                            <nav aria-label="Page navigation">
                                <ul class="pagination pagination-sm justify-content-end mb-0">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <g:link class="page-link" controller="resource" action="allTopics"
                                                params="[
                                                    max: max,
                                                    offset: offset - max < 0 ? 0 : offset - max,
                                                    sort: params.sort,
                                                    order: params.order,
                                                    search: params.search,
                                                    visibility: params.visibility
                                                ]">
                                            Previous
                                        </g:link>
                                    </li>

                                    <g:each in="${1..totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <g:link class="page-link" controller="resource" action="allTopics"
                                                    params="[
                                                        max: max,
                                                        offset: (i - 1) * max,
                                                        sort: params.sort,
                                                        order: params.order,
                                                        search: params.search,
                                                        visibility: params.visibility
                                                    ]">
                                                ${i}
                                            </g:link>
                                        </li>
                                    </g:each>

                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <g:link class="page-link" controller="resource" action="allTopics"
                                                params="[
                                                    max: max,
                                                    offset: offset + max,
                                                    sort: params.sort,
                                                    order: params.order,
                                                    search: params.search,
                                                    visibility: params.visibility
                                                ]">
                                            Next
                                        </g:link>
                                    </li>
                                </ul>
                            </nav>
                        </div>
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
                            <label for="topicForLink" class="form-label">Topic</label>
                            <select class="form-select" id="topicForLink" name="topicId" required>
                                <option value="" selected disabled>Select a topic</option>
                                <g:each in="${topics}" var="topic">
                                    <option value="${topic.id}">${topic.name}</option>
                                </g:each>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Share</button>
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
                            <label for="documentFile" class="form-label">Document</label>
                            <input type="file" class="form-control" id="documentFile" name="document" required>
                        </div>
                        <div class="mb-3">
                            <label for="documentDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="documentDescription" name="description" rows="3" placeholder="Enter description" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="topicForDocument" class="form-label">Topic</label>
                            <select class="form-select" id="topicForDocument" name="topicId" required>
                                <option value="" selected disabled>Select a topic</option>
                                <g:each in="${topics}" var="topic">
                                    <option value="${topic.id}">${topic.name}</option>
                                </g:each>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Share</button>
                    </div>
                </g:form>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
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
                    
                    // Update subscription count if provided
                    if (data.subCount !== undefined) {
                        const countElement = document.querySelector(`.subscription-count-${topicId}`);
                        if (countElement) {
                            countElement.textContent = data.subCount;
                        }
                    }
                    
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
                    
                    // Update subscription count if provided
                    if (data.subCount !== undefined) {
                        const countElement = document.querySelector(`.subscription-count-${topicId}`);
                        if (countElement) {
                            countElement.textContent = data.subCount;
                        }
                    }
                    
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
