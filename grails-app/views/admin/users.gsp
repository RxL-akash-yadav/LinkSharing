<%@ page import="com.example.Subscription" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Management</title>
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
    </style>
</head>
<body class="p-4">

<nav class="navbar navbar-expand navbar-dark m-4">
        <div class="container navbar-container">
            <g:link controller="user" action="dashboard" class="navbar-brand" style="color: blue">LinkSharing</g:link>


            <div class="d-flex align-items-center ms-auto">

                <!-- Action Buttons -->
                <div class="d-flex align-items-center me-3">
                    <button type="button" class="btn btn-link p-0 me-3" data-bs-toggle="modal" data-bs-target="#createTopicModal">
                        <i class="bi bi-chat-dots-fill fs-4 text-dark"></i>
                    </button>
                    <button type="button" class="btn btn-link p-0 me-3" data-bs-toggle="modal" data-bs-target="#invitationModal">
                        <i class="bi bi-envelope fs-4 text-dark"></i>
                    </button>
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
                            <img src="${createLink(controller: 'user', action: 'photo', id: session.user.id)}" alt="User Profile" class="rounded-circle" width="30">
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><g:link class="dropdown-item" controller="user" action="editprofile">Profile</g:link></li>
                            <li><g:link class="dropdown-item" controller="admin" action="users">Users</g:link></li>
                            <li><g:link class="dropdown-item" controller="admin" action="topics">Topics</g:link></li>
                            <li><g:link class="dropdown-item" controller="admin" action="posts">Posts</g:link></li>
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
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </g:if>
    <g:if test="${flash.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${flash.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </g:if>
</div>

    <!-- Main Container -->
    <div class="container mt-4 p-4" style="border:none; box-shadow: none;">
        <div class="row">
            <div class="col-12">
                <!-- Users Management Card -->
                <div class="content-card">
                    <div class="content-header">
                        <span>User Management</span>
                        <div class="d-flex align-items-center ms-auto">
                            <g:form controller="admin" action="users" method="get" class="d-flex align-items-center gap-3 mb-0">
                                <div class="d-flex align-items-center">
                                    <label class="me-2 mb-0">Status:</label>
                                    <select name="status" class="form-select form-select-sm" style="width: 120px;" onchange="this.form.submit()">
                                        <option value="" ${!params.status ? 'selected' : ''}>All Users</option>
                                        <option value="active" ${params.status == 'active' ? 'selected' : ''}>Active</option>
                                        <option value="inactive" ${params.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                                <div class="d-flex gap-2" style="max-width: 300px;">
                                    <input type="search" name="search" class="form-control form-control-sm"
                                           placeholder="Username/Email" value="${params.search ?: ''}">
                                    <button type="submit" class="btn btn-dark btn-sm">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                                <input type="hidden" name="sort" value="${params.sort ?: 'id'}" />
                                <input type="hidden" name="order" value="${params.order ?: 'asc'}" />
                                <input type="hidden" name="max" value="${params.max ?: 20}" />
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
                                            <g:link controller="admin" action="users"
                                                    params="[sort: 'id', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Id ${params.sort == 'id' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>
                                            <g:link controller="admin" action="users"
                                                    params="[sort: 'username', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Username ${params.sort == 'username' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>
                                            <g:link controller="admin" action="users"
                                                    params="[sort: 'email', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Email ${params.sort == 'email' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>
                                            <g:link controller="admin" action="users"
                                                    params="[sort: 'firstName', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Firstname ${params.sort == 'firstName' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>
                                            <g:link controller="admin" action="users"
                                                    params="[sort: 'lastName', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Lastname ${params.sort == 'lastName' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>
                                            <g:link controller="admin" action="users"
                                                    params="[sort: 'active', order: params.order == 'asc' ? 'desc' : 'asc',
                                                            max: params.max, offset: params.offset,
                                                            search: params.search, status: params.status]"
                                                    class="sort-link">
                                                Active ${params.sort == 'active' ? (params.order == 'asc' ? '&#9650;' : '&#9660;')?.encodeAsRaw() : ''}
                                            </g:link>
                                        </th>
                                        <th>Manage</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <g:each in="${users}" var="user">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>${user.username}</td>
                                            <td>${user.email}</td>
                                            <td>${user.firstName}</td>
                                            <td>${user.lastName}</td>
                                            <td>
                                                <span class="badge ${user.active ? 'bg-success' : 'bg-danger'}">
                                                    ${user.active ? 'Yes' : 'No'}
                                                </span>
                                            </td>
                                            <td>
                                                <g:if test="${user.active}">
                                                    <g:link controller="admin" action="deactivate" params="[userId: user.id]"
                                                            class="btn btn-sm btn-outline-danger">
                                                        Deactivate
                                                    </g:link>
                                                </g:if>
                                                <g:else>
                                                    <g:link controller="admin" action="activate" params="[userId: user.id]"
                                                            class="btn btn-sm btn-outline-success">
                                                        Activate
                                                    </g:link>
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
                                int totalPages = Math.ceil(totalUsers / max) as int
                            %>
                            <nav aria-label="Page navigation">
                                <ul class="pagination pagination-sm justify-content-end mb-0">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <g:link class="page-link" controller="admin" action="users"
                                                params="[max: max, offset: offset - max < 0 ? 0 : offset - max,
                                                        sort: params.sort, order: params.order,
                                                        search: params.search, status: params.status]">
                                            Previous
                                        </g:link>
                                    </li>

                                    <g:each in="${1..totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <g:link class="page-link" controller="admin" action="users"
                                                    params="[max: max, offset: (i - 1) * max,
                                                            sort: params.sort, order: params.order,
                                                            search: params.search, status: params.status]">
                                                ${i}
                                            </g:link>
                                        </li>
                                    </g:each>

                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <g:link class="page-link" controller="admin" action="users"
                                                params="[max: max, offset: offset + max,
                                                        sort: params.sort, order: params.order,
                                                        search: params.search, status: params.status]">
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
</nav>

<!-- Modals -->

    <!-- Create Topic Modal -->
    <div class="modal fade" id="createTopicModal" tabindex="-1" aria-labelledby="createTopicModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createTopicModalLabel">Create Topic</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="createTopicError" class="alert alert-danger d-none"></div>
                    <div class="mb-3">
                        <label for="topicName" class="form-label">Topic Name</label>
                        <input type="text" class="form-control" id="topicName" name="name" placeholder="Enter topic name" required>
                    </div>
                    <div class="mb-3">
                        <label for="visibility" class="form-label">Visibility</label>
                        <select class="form-select" id="visibility" name="visibility" required>
                            <option value="PUBLIC">Public</option>
                            <option value="PRIVATE">Private</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="createTopicBtn" class="btn btn-primary">Create Topic</button>
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
                <div class="modal-body">
                    <div id="inviteError" class="alert alert-danger d-none"></div>
                    <div class="mb-3">
                        <label for="inviteEmail" class="form-label">Email address</label>
                        <input type="email" class="form-control" id="inviteEmail" name="email" placeholder="Enter email" required>
                    </div>
                    <div class="mb-3">
                        <label for="topicSelect" class="form-label">Select Topic</label>
                        <select id="topicSelect" name="topicId" class="form-select" required>
                            <option value="" disabled selected>Select a topic</option>
                            <g:each in="${Subscription.findAllByUser(session.user)}" var="sub">
                                <option value="${sub.topic.id}">${sub.topic.name}</option>
                            </g:each>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="sendInviteBtn" class="btn btn-primary rounded-pill">Send</button>
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
                                <g:each in="${Subscription.findAllByUser(session.user)}" var="sub">
                                    <option value="${sub.topic.id}">${sub.topic.name}</option>
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
                                <g:each in="${Subscription.findAllByUser(session.user)}" var="sub">
                                    <option value="${sub.topic.id}">${sub.topic.name}</option>
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
    // Function to create topic via AJAX
    function createTopic() {
        const topicName = document.getElementById('topicName').value.trim();
        const visibility = document.getElementById('visibility').value;
        const errorDiv = document.getElementById('createTopicError');
        
        if (!topicName) {
            errorDiv.textContent = "Topic name is required";
            errorDiv.classList.remove('d-none');
            return;
        }
        
        // Disable button and show loading state
        const createBtn = document.getElementById('createTopicBtn');
        const originalBtnText = createBtn.textContent;
        createBtn.disabled = true;
        createBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Creating...';
        
        // Clear previous errors
        errorDiv.classList.add('d-none');
        
        fetch('${createLink(controller: 'topic', action: 'create')}', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: new URLSearchParams({
                'name': topicName,
                'visibility': visibility
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Close modal
                const modal = bootstrap.Modal.getInstance(document.getElementById('createTopicModal'));
                modal.hide();
                
                // Show success notification
                showNotification(data.message, 'success');
                
                // Reset form
                document.getElementById('topicName').value = '';
                
                // Update topic selectors if available
                updateTopicSelectors(data.topic);
                
            } else {
                // Show error
                errorDiv.textContent = data.error || "Failed to create topic";
                errorDiv.classList.remove('d-none');
            }
        })
        .catch(error => {
            console.error('Error creating topic:', error);
            errorDiv.textContent = "An error occurred while creating the topic";
            errorDiv.classList.remove('d-none');
        })
        .finally(() => {
            // Reset button state
            createBtn.disabled = false;
            createBtn.textContent = originalBtnText;
        });
    }
    
    // Function to send invitation via AJAX
    function sendInvitation() {
        const email = document.getElementById('inviteEmail').value.trim();
        const topicId = document.getElementById('topicSelect').value;
        const errorDiv = document.getElementById('inviteError');
        
        if (!email || !topicId) {
            errorDiv.textContent = "Email and topic are required";
            errorDiv.classList.remove('d-none');
            return;
        }
        
        // Disable button and show loading state
        const sendBtn = document.getElementById('sendInviteBtn');
        const originalBtnText = sendBtn.textContent;
        sendBtn.disabled = true;
        sendBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Sending...';
        
        // Clear previous errors
        errorDiv.classList.add('d-none');
        
        fetch('${createLink(controller: 'topic', action: 'send')}', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: new URLSearchParams({
                'email': email,
                'topicId': topicId
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Close modal
                const modal = bootstrap.Modal.getInstance(document.getElementById('invitationModal'));
                modal.hide();
                
                // Show success notification
                showNotification(data.message, 'success');
                
                // Reset form
                document.getElementById('inviteEmail').value = '';
                document.getElementById('topicSelect').value = '';
                
            } else {
                // Show error
                errorDiv.textContent = data.error || "Failed to send invitation";
                errorDiv.classList.remove('d-none');
            }
        })
        .catch(error => {
            console.error('Error sending invitation:', error);
            errorDiv.textContent = "An error occurred while sending the invitation";
            errorDiv.classList.remove('d-none');
        })
        .finally(() => {
            // Reset button state
            sendBtn.disabled = false;
            sendBtn.textContent = originalBtnText;
        });
    }
    
    // Function to update topic selectors after a new topic is created
    function updateTopicSelectors(topic) {
        if (!topic || !topic.id) return;
        
        // Update all topic selectors in the page
        const selectors = ['topicSelect', 'topicSelectShare', 'topicSelectDoc'];
        selectors.forEach(selectorId => {
            const selector = document.getElementById(selectorId);
            if (selector) {
                const option = document.createElement('option');
                option.value = topic.id;
                option.textContent = topic.name;
                selector.appendChild(option);
            }
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

    // Initialize when DOM is loaded
    document.addEventListener("DOMContentLoaded", () => {
        try {
            // Set up event listeners for topic creation and invitation
            const createTopicBtn = document.getElementById('createTopicBtn');
            const sendInviteBtn = document.getElementById('sendInviteBtn');
            
            if (createTopicBtn) {
                createTopicBtn.addEventListener('click', createTopic);
            }
            
            if (sendInviteBtn) {
                sendInviteBtn.addEventListener('click', sendInvitation);
            }
        } catch (error) {
            console.error('Error in DOM load handler:', error);
        }
    });
</script>

</body>
</html>
