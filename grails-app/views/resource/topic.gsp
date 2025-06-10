<%@ page import="com.example.Subscription" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Topic Show - LinkSharing</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
    body {
        background-color: #f9f9f9;
    }
    .navbar-container {
        z-index: 2;
        box-shadow: 0 5px 8px gray;
        background-color: #f8f9fa;
        color: black;
        border: 1px solid black;
        border-radius: 5px;
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

<!-- Main Content -->
<div class="container mb-5">
    <div class="row">
        <!-- Left Column -->
        <div class="col-md-4">
            <!-- Topic Card -->
            <div class="content-card mb-4">
                <div class="content-header d-flex align-items-center">
                    <span>Topic</span>
                </div>
                <div class="content-body">
                    <div class="d-flex gap-3 align-items-center mb-3 pb-3">
                        <a href="${createLink(controller: 'user', action: 'profile', id: topic.createdBy.id)}">
                            <img src="${createLink(controller: 'user', action: 'photo', id: topic.createdBy.id)}"
                                 onerror="this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                                 class="rounded-circle" width="70" height="70" style="object-fit: cover;" alt="Profile">
                        </a>
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center justify-content-between mb-1">
                                <span class="text-muted" style="font-size: 1.1rem; font-weight: 500;">
                                    ${topic.name}
                                </span>
                                <span class="badge bg-light text-dark ms-2" style="font-size: 0.85rem;">
                                    ${topic.visibility}
                                </span>
                            </div>
                            <div>
                                @<g:link controller="user" action="profile" id="${topic.createdBy.id}" class="text-decoration-none text-muted">${topic.createdBy.username}</g:link>
                            </div>
                            <div class="d-flex align-items-center gap-3 mt-2 mb-2">
                                <span>
                                    Subscriptions: <span class="fw-bold" id="subCount">${subCount}</span>
                                </span>
                                <span>Posts: <span class="fw-bold">${postCount}</span></span>
                            </div>
                            <div>
                                <g:set var="isSubscribed" value="${Subscription.findByUserAndTopic(session.user, topic) != null}" />
                                <button id="subscribeBtn"
                                        class="btn btn-sm ${isSubscribed ? 'btn-outline-danger' : 'btn-outline-primary'} mt-2 subscribe-btn"
                                        data-topic-id="${topic.id}">
                                    ${isSubscribed ? 'Unsubscribe' : 'Subscribe'}
                                </button>
                            </div>
                        </div>
                    </div>
                    <g:if test="${Subscription.findByUserAndTopic(session.user, topic)}">
                        <div class="d-flex justify-content-between align-items-center mt-2">
                        </div>
                    </g:if>
                </div>
            </div>
            <!-- Users Card -->
            <input type="hidden" id="topicId" value="${topic.id}" />
            <div id="userListSection">
                <g:render template="/resource/topicUserList" model="[users: users, topic: topic, offset: offset, max: max, totalUsers: totalUsers]" />
            </div>
        </div>
        <!-- Right Column -->
        <div class="col-md-8">
            <!-- Posts Card -->
            <div class="content-card">
                <div class="content-header d-flex justify-content-between align-items-center">
                    <span>Posts: "${topic?.name ?: 'All'}"</span>
                    <div class="input-group w-50">
                        <form id="searchForm" class="d-flex w-100" method="get" action="${createLink(controller:'resource', action:'topicPosts')}">
                            <input type="hidden" name="id" value="${topic?.id}"/>
                            <input type="text" class="form-control form-control-sm" name="q" value="${query}" placeholder="Search posts" />
                            <button class="btn btn-sm btn-dark" type="submit"><i class="fas fa-search"></i></button>
                        </form>
                    </div>
                </div>
                <div class="content-body p-0" id="postsContainer">
                    <input type="hidden" name="id" value="${topic?.id}" />
                    <g:render template="topicPosts" model="[posts: posts, offset: offset ?: 0, max: max ?: 5, totalCount: totalCount ?: posts?.size() ?: 0]" />
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
                            <!-- Disabled dropdown for display -->
                            <select id="topicSelectDisplay" class="form-select" disabled>
                                <option id="topicOptionDisplay">Loading...</option>
                            </select>

                            <!-- Hidden topicId input for actual form submission -->
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
document.addEventListener('DOMContentLoaded', function () {
    const invitationModal = document.getElementById('invitationModal');
    if (invitationModal) {
        invitationModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const topicId = button.getAttribute('data-topic-id');
            const topicName = button.getAttribute('data-topic-name');

            invitationModal.querySelector('#topicId').value = topicId;
            const displayOption = invitationModal.querySelector('#topicOptionDisplay');
            displayOption.textContent = topicName;
            displayOption.value = topicId;
        });

        loadTopicUsers(0);
        loadPosts(0);
    }
    
    // Add event listener for subscribe/unsubscribe button
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


function loadTopicUsers(offset = 0) {
    const topicIdInput = document.getElementById("topicId");
    if (!topicIdInput) return;

    const topicId = topicIdInput.value;
    const url = '/resource/loadTopicUsersAjax?topicId=' + topicId + '&offset=' + offset + '&max=5';

    fetch(url, {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(response => {
        if (!response.ok) throw new Error("Failed to load users");
        return response.text();
    })
    .then(html => {
        document.getElementById("userListSection").innerHTML = html;
        attachUserPaginationListeners(); // Rebind pagination links
    })
    .catch(err => console.error("Error loading topic users:", err));
}

function attachUserPaginationListeners() {
    document.querySelectorAll('.user-page-link').forEach(link => {
        link.addEventListener('click', e => {
            e.preventDefault();
            const offset = e.target.getAttribute('data-offset');
            loadTopicUsers(parseInt(offset));
        });
    });
}
function loadPosts(offset = 0) {
    const topicId = document.querySelector('input[name="id"]').value;
    const max = 5; // fixed page size

    // Get the search input value directly from the form input
    const searchInput = document.querySelector('#searchForm input[name="q"]');
    const q = searchInput ? searchInput.value.trim() : '';

    const params = new URLSearchParams({
        topicId: topicId,
        offset: offset,
        max: max
    });

    if (q) {
        params.append('q', q);
    }

    const url = '/resource/topicPosts?' + params.toString();

    fetch(url, {
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (!response.ok) throw new Error('Failed to load posts');
        return response.text();
    })
    .then(html => {
        document.getElementById('postsContainer').innerHTML = html;
    })
    .catch(error => {
        console.error('Error loading posts:', error);
    });
}



function attachPostPaginationListeners() {
    document.querySelectorAll('.post-page-link').forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const offset = e.target.getAttribute('data-offset');
            loadPosts(parseInt(offset));
        });
    });
}

document.getElementById('searchForm').addEventListener('submit', function(e) {
    e.preventDefault();   // prevent full page reload on submit
    loadPosts(0);         // load first page of search results via AJAX
});

function ajaxSubscribe(topicId, btn) {
    // Disable button and show loading state
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
            
            // Reload the users list to show the new subscriber
            loadTopicUsers(0);
            
            // Update the subscription count if available
            const subCountElement = document.getElementById('subCount');
            if (subCountElement) {
                const currentCount = parseInt(subCountElement.textContent || '0');
                subCountElement.textContent = currentCount + 1;
            }
            
            // If there's a seriousness section that should now be shown
            const seriosSection = document.querySelector('.seriousness-section');
            if (seriosSection) {
                seriosSection.classList.remove('d-none');
            }
        } else {
            // Show error and reset button
            showNotification(data.message || 'Failed to subscribe', 'danger');
        }
    })
    .catch(error => {
        console.error('Error subscribing:', error);
        showNotification('Error: Could not connect to server', 'danger');
    })
    .finally(() => {
        btn.disabled = false;
    });
}

function ajaxUnsubscribe(topicId, btn) {
    // Disable button and show loading state
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
            
            // Reload the users list to remove the ex-subscriber
            loadTopicUsers(0);
            
            // Update the subscription count if available
            const subCountElement = document.getElementById('subCount');
            if (subCountElement) {
                const currentCount = parseInt(subCountElement.textContent || '0');
                subCountElement.textContent = Math.max(0, currentCount - 1);
            }
            
            // If there's a seriousness section that should now be hidden
            const seriosSection = document.querySelector('.seriousness-section');
            if (seriosSection) {
                seriosSection.classList.add('d-none');
            }
        } else {
            // Show error and reset button
            showNotification(data.message || 'Failed to unsubscribe', 'danger');
        }
    })
    .catch(error => {
        console.error('Error unsubscribing:', error);
        showNotification('Error: Could not connect to server', 'danger');
    })
    .finally(() => {
        btn.disabled = false;
    });
}

// Add notification function
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
