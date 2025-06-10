<%@ page import="com.example.Subscription" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RESOURCE PAGE</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
    .navbar-container {
        z-index: 2;
        box-shadow: 0 5px 8px gray;
        background-color: #f8f9fa;
        color: black;
        border: 1px solid black;
        border-radius: 5px;
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
    .alert-floating {
        position: fixed;
        top: 10px;
        right: 10px;
        z-index: 9999;
        max-width: 300px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }
    </style>
</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

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
                            <input class="form-control" type="search" name="q" placeholder="Search">
                            <button class="btn btn-dark" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </g:form>

                    <!-- User Profile Dropdown -->
                    <div class="d-flex align-items-center">
                        <a href="${createLink(controller: 'user', action: 'profile', id: session.user?.id)}" class="text-decoration-none text-dark me-2">
                            ${session.user?.firstName}
                        </a>
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

<!-- Main Content -->
<div class="container mt-4" style="border-style: none">
    <div class="row">
        <div class="col-md-7 mt-3">
            <div class="content-card">
                <div class="content-header">
                    <span>Post Details</span>
                </div>
                <div class="content-body p-0">
                    <div class="post-item">
                        <div class="d-flex gap-3">
                            <a href="${createLink(controller: 'user', action: 'profile', id: resource.createdBy.id)}" class="flex-shrink-0">
                                <img src="${createLink(controller: 'user', action: 'photo', id: resource.createdBy.id)}"
                                     onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                                     alt="User Profile" class="rounded-circle" width="100" style="object-fit: cover;">
                            </a>
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <strong>
                                        <a href="${createLink(controller: 'user', action: 'profile', id: resource.createdBy.id)}" class="text-decoration-none text-dark">
                                            ${resource.createdBy.firstName} ${resource.createdBy.lastName}
                                        </a>
                                    </strong>
                                    <a href="${createLink(controller: 'resource', action: 'topic', id: resource.topic.id)}" class="text-decoration-none badge bg-light text-dark">
                                        ${resource.topic.name}
                                    </a>
                                </div>
                                <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                                    <span>
                                        <a href="${createLink(controller: 'user', action: 'profile', id: resource.createdBy.id)}" class="text-decoration-none text-muted">
                                            @${resource.createdBy.username}
                                        </a>
                                    </span>
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
                                    <div class="d-flex align-items-center flex-wrap gap-2">
                                        <g:if test="${session.user && session.user.id == resource.createdBy.id}">
                                            <g:link controller="resource" action="deleteResource" id="${resource.id}"
                                                    class="btn btn-outline-danger btn-sm"
                                                    onclick="return confirm('Are you sure you want to delete this resource?')">
                                                Delete
                                            </g:link>
                                            <g:if test="${resource instanceof com.example.DocumentResource}">
                                                <a href="#" class="btn btn-outline-primary btn-sm"
                                                   data-bs-toggle="modal"
                                                   data-bs-target="#editDocumentModal"
                                                   data-id="${resource.id}"
                                                   data-description="${resource.description}"
                                                   data-topic-id="${resource.topic.id}"
                                                   data-topic-name="${resource.topic.name}">
                                                    Edit
                                                </a>
                                            </g:if>
                                            <g:elseif test="${resource instanceof com.example.LinkResource}">
                                                <a href="#" class="btn btn-outline-primary btn-sm"
                                                   data-bs-toggle="modal"
                                                   data-bs-target="#editLinkModal"
                                                   data-id="${resource.id}"
                                                   data-url="${resource.url}"
                                                   data-description="${resource.description}"
                                                   data-topic-id="${resource.topic.id}"
                                                   data-topic-name="${resource.topic.name}">
                                                    Edit
                                                </a>
                                            </g:elseif>
                                        </g:if>
                                        <g:if test="${resource instanceof com.example.DocumentResource}">
                                            <a href="/resource/download/${resource.id}" class="btn btn-outline-success btn-sm">
                                                Download
                                            </a>
                                        </g:if>
                                        <g:elseif test="${resource instanceof com.example.LinkResource}">
                                            <a href="${resource.url}" class="btn btn-outline-success btn-sm" target="_blank">
                                                View full site
                                            </a>
                                        </g:elseif>
                                    </div>
                                </div>
                                <g:if test="${session.user}">
                                    <div class="rating-stars mt-3" data-resource-id="${resource.id}">
                                        <g:each in="${(1..5)}" var="i">
                                            <i class="bi bi-star" data-score="${i}" style="cursor: pointer; margin-right: 2px; font-size: 1.2rem;"></i>
                                        </g:each>
                                    </div>
                                    <div id="rating-info-${resource.id}" class="mt-1 small text-muted">
                                        <span class="rating-placeholder">Loading rating...</span>
                                    </div>
                                </g:if>
                                <g:else>
                                    <div id="rating-info-${resource.id}" class="mt-3 small text-muted">
                                        <span class="rating-placeholder">Loading rating...</span>
                                    </div>
                                </g:else>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Trending Topics Card or Login/Register -->
        <div class="col-md-5 mt-3">
            <g:if test="${session.user}">
                <div class="content-card">
                    <div class="content-header">Trending Topics</div>
                    <div class="content-body p-0" id="trendingTopicsContainer">
                        <div class="text-center py-4">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </g:if>
            <g:else>
                <!-- Login Card (Homepage style) -->
                <div class="form-card mb-4" style="border-radius:10px;overflow:hidden;box-shadow:0 3px 10px rgba(0,0,0,0.15);margin-bottom:25px;">
                    <div class="form-header" style="background-color:#555;color:white;font-weight:bold;padding:15px 20px;">Login</div>
                    <div class="form-body" style="padding:20px;background-color:white;">
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
                                <a href="${createLink(controller: 'home', action: 'forgotPassword')}">Forgot password</a>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Login</button>
                        </g:form>
                    </div>
                </div>
                <!-- Register Card (Homepage style) -->
                <div class="form-card" style="border-radius:10px;overflow:hidden;box-shadow:0 3px 10px rgba(0,0,0,0.15);margin-bottom:25px;">
                    <div class="form-header" style="background-color:#555;color:white;font-weight:bold;padding:15px 20px;">Register</div>
                    <div class="form-body" style="padding:20px;background-color:white;">
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
            </g:else>
        </div>
    </div>
</div>

<!-- Modals -->
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
    <!-- Edit Link Modal -->
    <div class="modal fade" id="editLinkModal" tabindex="-1" aria-labelledby="editLinkModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 shadow">
                <div class="modal-header">
                    <h5 class="modal-title" id="editLinkModalLabel">Edit Link</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editLinkForm" method="POST">
                    <div class="modal-body">
                        <div id="linkEditAlert" class="alert d-none"></div>
                        <input type="hidden" name="resourceId" id="editLinkResourceId" value="" />
                        <div class="mb-3">
                            <label for="editLinkUrl" class="form-label">Link URL</label>
                            <input type="url" class="form-control" id="editLinkUrl" name="link" value="" required>
                        </div>
                        <div class="mb-3">
                            <label for="editLinkDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="editLinkDescription" name="description" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Topic</label>
                            <p class="form-control-plaintext" id="editLinkTopicDisplay">Loading...</p>
                            <input type="hidden" name="topicId" id="editLinkTopicId" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Document Modal -->
    <div class="modal fade" id="editDocumentModal" tabindex="-1" aria-labelledby="editDocumentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content rounded-4 shadow">
            <div class="modal-header">
                <h5 class="modal-title" id="editDocumentModalLabel">Edit Document</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="editDocumentForm" method="POST" enctype="multipart/form-data">
                <div class="modal-body">
                    <div id="documentEditAlert" class="alert d-none"></div>
                    <input type="hidden" name="resourceId" id="editDocResourceId" value="" />
                    <div class="mb-3">
                        <label for="editDocumentFile" class="form-label">Replace Document (optional)</label>
                        <input type="file" class="form-control" id="editDocumentFile" name="filepath" accept=".pdf,.doc,.docx,.txt">
                        <small class="form-text text-muted">Leave empty to keep the current file.</small>
                    </div>
                    <div class="mb-3">
                        <label for="editDocDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="editDocDescription" name="description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Topic</label>
                        <p class="form-control-plaintext" id="editDocTopicDisplay">Loading...</p>
                        <input type="hidden" name="topicId" id="editDocTopicId" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>


<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Populate Edit Link Modal
        const editLinkModal = document.getElementById("editLinkModal");
        editLinkModal.addEventListener("show.bs.modal", function (event) {
            const button = event.relatedTarget;
            const id = button.getAttribute("data-id");
            const url = button.getAttribute("data-url");
            const description = button.getAttribute("data-description");
            const topicId = button.getAttribute("data-topic-id");
            const topicName = button.getAttribute("data-topic-name");

            const form = editLinkModal.querySelector("form");
            form.action = `/resource/editLink/${id}`;
            form.querySelector("#editLinkUrl").value = url;
            form.querySelector("#editLinkDescription").value = description;
            form.querySelector("#editLinkTopicSelect").innerHTML = `<option selected>${topicName}</option>`;
            form.querySelector("#editLinkTopicId").value = topicId;
        });

        // Populate Edit Document Modal
        const editDocumentModal = document.getElementById("editDocumentModal");
        editDocumentModal.addEventListener("show.bs.modal", function (event) {
            const button = event.relatedTarget;
            const id = button.getAttribute("data-id");
            const description = button.getAttribute("data-description");
            const topicId = button.getAttribute("data-topic-id");
            const topicName = button.getAttribute("data-topic-name");
            const filename = button.getAttribute("data-filename");

            const form = editDocumentModal.querySelector("form");
            form.action = `/resource/editDocument/${id}`;
            form.querySelector("#editDocDescription").value = description;
            form.querySelector("#editDocTopicSelect").innerHTML = `<option selected>${topicName}</option>`;
            form.querySelector("#editDocTopicId").value = topicId;
            form.querySelector("#editDocFileName").textContent = `Current file: ${filename}`;
        });
        
        // Load trending topics
        loadTrendingTopics();
        
        // Set up event delegation for subscribe/unsubscribe buttons
        document.body.addEventListener('click', function(e) {
            const btn = e.target.closest('.subscribe-btn');
            if (!btn) return;
            
            const topicId = btn.getAttribute('data-topic-id');
            if (btn.textContent.trim() === 'Subscribe') {
                ajaxSubscribe(topicId, btn);
            } else if (btn.textContent.trim() === 'Unsubscribe') {
                ajaxUnsubscribe(topicId, btn);
            }
        });
    });
    
    // Utility function to show floating notifications
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

    // Rating system initialization
    $(document).ready(function () {
          console.log('Rating system initializing...');

          $('[id^=rating-info-]').each(function () {
              let resourceId = $(this).attr('id').replace('rating-info-', '');
              loadRatingInfo(resourceId);
          });

          // Logged-in only behavior
          $('.rating-stars').each(function () {
              let resourceId = $(this).data('resource-id');
              console.log('Processing rating UI for resource:', resourceId);

              // Load user's current rating
              $.get('/resource/getUserRating', {resourceId: resourceId})
                  .done(function (response) {
                      updateStarDisplay(resourceId, response.score);
                  });

              // Star click handler
              $(this).find('i').on('click', function () {
                  let selectedScore = $(this).data('score');
                  $.post('/resource/rate', {
                      resourceId: resourceId,
                      score: selectedScore
                  })
                  .done(function (response) {
                      updateStarDisplay(resourceId, selectedScore);
                      updateRatingInfo(resourceId, response.averageRating, response.totalRatings);
                  });
              });
          });

          function updateStarDisplay(resourceId, score) {
              let stars = $('.rating-stars[data-resource-id="' + resourceId + '"] i');
              stars.removeClass('bi-star-fill').addClass('bi-star');
              stars.each(function () {
                  if ($(this).data('score') <= score) {
                      $(this).removeClass('bi-star').addClass('bi-star-fill');
                  }
              });
          }

          function updateRatingInfo(resourceId, averageRating, totalRatings) {
              $('#rating-info-' + resourceId).html(
                  '<span class="rating-display">' +
                  'Average Rating: <strong>' + averageRating + '</strong> ★ (' +
                  totalRatings + ' ' + (totalRatings === 1 ? 'user' : 'users') + ')' +
                  '</span>'
              );
          }

          function loadRatingInfo(resourceId) {
              $.get('/resource/getRatingInfo', {resourceId: resourceId})
                  .done(function (response) {
                      updateRatingInfo(resourceId, response.averageRating, response.totalRatings);
                  })
                  .fail(function () {
                      $('#rating-info-' + resourceId).html('Rating unavailable');
                  });
          }
      });

    // Simplified loadTrendingTopics function
    function loadTrendingTopics() {
        console.log('Loading trending topics...');
        
        fetch('${createLink(controller: 'resource', action: 'trendingTopics')}', {
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => response.text())
        .then(html => {
            document.getElementById('trendingTopicsContainer').innerHTML = html;
        })
        .catch(err => {
            document.getElementById('trendingTopicsContainer').innerHTML = 
                '<div class="p-3"><div class="alert alert-danger">Failed to load trending topics. Please refresh the page.</div></div>';
            console.error('Error loading trending topics:', err);
        });
    }
    
    // Functions for subscribe/unsubscribe operations
    function ajaxSubscribe(topicId, btn) {
        fetch('/user/ajaxSubscribe?topicId=' + topicId, {
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
                showNotification('Subscribed successfully', 'success');
                
                // Refresh trending topics
                loadTrendingTopics();
            } else {
                showNotification(data.message || 'Failed to subscribe', 'danger');
            }
        })
        .catch(error => {
            console.error('Error subscribing:', error);
            showNotification('Failed to subscribe. Please try again.', 'danger');
        });
    }

    function ajaxUnsubscribe(topicId, btn) {
        fetch('/user/ajaxUnsubscribe?topicId=' + topicId, {
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
                showNotification('Unsubscribed successfully', 'success');
                
                // Refresh trending topics
                loadTrendingTopics();
            } else {
                showNotification(data.message || 'Failed to unsubscribe', 'danger');
            }
        })
        .catch(error => {
            console.error('Error unsubscribing:', error);
            showNotification('Failed to unsubscribe. Please try again.', 'danger');
        });
    }
    
    // Edit form AJAX submissions
    $(document).ready(function() {
        // Link edit form AJAX submission
        $('#editLinkForm').on('submit', function(e) {
            e.preventDefault();

            const resourceId = $('#editLinkResourceId').val();
            const url = $('#editLinkUrl').val();
            const description = $('#editLinkDescription').val();

            $.ajax({
                url: '${createLink(controller: 'resource', action: 'editLink')}',
                type: 'POST',
                data: {
                    resourceId: resourceId,
                    link: url,
                    description: description
                },
                success: function(response) {
                    if (response.success) {
                        // Close modal
                        $('#editLinkModal').modal('hide');

                        // Show success message
                        showFloatingAlert('success', response.message);

                        // Update content on page
                        updatePostContent(response.resource);
                    } else {
                        // Show error in modal
                        $('#linkEditAlert')
                            .removeClass('d-none alert-success')
                            .addClass('alert-danger')
                            .text(response.message);
                    }
                },
                error: function() {
                    $('#linkEditAlert')
                        .removeClass('d-none alert-success')
                        .addClass('alert-danger')
                        .text('An error occurred while updating the link.');
                }
            });
        });

        // Document edit form AJAX submission
        $('#editDocumentForm').on('submit', function(e) {
            e.preventDefault();
            
            // Create FormData object to handle file uploads
            var formData = new FormData(this);
            
            $.ajax({
                url: '${createLink(controller: 'resource', action: 'editDocument')}',
                type: 'POST',
                data: formData,
                processData: false,  // Don't process the data
                contentType: false,  // Don't set content type (browser will set it with boundary)
                success: function(response) {
                    if (response.success) {
                        // Close modal
                        $('#editDocumentModal').modal('hide');
                        
                        // Show success message
                        showFloatingAlert('success', response.message);
                        
                        // Update content on page
                        updatePostContent(response.resource);
                        
                        // Reload the page after a short delay if a new file was uploaded
                        if ($('#editDocumentFile')[0].files.length > 0) {
                            setTimeout(function() {
                                location.reload();
                            }, 2000);
                        }
                    } else {
                        // Show error in modal
                        $('#documentEditAlert')
                            .removeClass('d-none alert-success')
                            .addClass('alert-danger')
                            .text(response.message);
                    }
                },
                error: function(xhr, status, error) {
                    $('#documentEditAlert')
                        .removeClass('d-none alert-success')
                        .addClass('alert-danger')
                        .text('An error occurred while updating the document: ' + error);
                }
            });
        });

        // Helper function to show floating alerts
        function showFloatingAlert(type, message) {
            const alertDiv = $('<div class="alert alert-' + type + ' alert-floating alert-dismissible fade show">' +
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                '</div>');

            $('body').append(alertDiv);

            // Auto dismiss after 5 seconds
            setTimeout(function() {
                alertDiv.alert('close');
            }, 5000);
        }

        // Update post content on the page
        function updatePostContent(resource) {
            // Update the description in the post
            $('.post-item p.mb-2').text(resource.description);

            // If it's a link resource and has a URL, update the view button href
            if (resource.url) {
                $('.post-item a.btn-outline-success').attr('href', resource.url);
            }
        }
    });

    // Fix: Modal handlers
    document.addEventListener('DOMContentLoaded', function() {
        // Modified event handler for editLinkModal
        const editLinkModal = document.getElementById('editLinkModal');
        if (editLinkModal) {
            editLinkModal.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;

                const id = button.getAttribute('data-id');
                const url = button.getAttribute('data-url');
                const description = button.getAttribute('data-description');
                const topicId = button.getAttribute('data-topic-id');
                const topicName = button.getAttribute('data-topic-name');

                // Reset previous alert messages
                $('#linkEditAlert').addClass('d-none');

                // Set form values
                $('#editLinkResourceId').val(id);
                $('#editLinkUrl').val(url);
                $('#editLinkDescription').val(description);
                $('#editLinkTopicId').val(topicId);
                $('#editLinkTopicDisplay').text(topicName);
            });
        }

        // Modified event handler for editDocumentModal
        const editDocumentModal = document.getElementById('editDocumentModal');
        if (editDocumentModal) {
            editDocumentModal.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;

                const id = button.getAttribute('data-id');
                const description = button.getAttribute('data-description');
                const topicId = button.getAttribute('data-topic-id');
                const topicName = button.getAttribute('data-topic-name');

                // Reset previous alert messages
                $('#documentEditAlert').addClass('d-none');

                // Set form values
                $('#editDocResourceId').val(id);
                $('#editDocDescription').val(description);
                $('#editDocTopicId').val(topicId);
                $('#editDocTopicDisplay').text(topicName);
            });
        }
    });
</script>




</body>
</html>