<%@ page import="com.example.Subscription" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
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

        .profile-image {
            height: 100px;
            width: 100px;
            border-radius: 50%;
        }

        .post-image {
            height: 80px;
            width: 80px;
            border-radius: 50%;
        }

        .topic-image {
            height: 100px;
            width: 100px;
        }
        .dropdown-menu {
            z-index: 9999 !important;
        }

        /* Solution 2: Set navbar container z-index */
        .navbar-container {
            position: relative;
            z-index: 1000;
        }
        .main-content {
            min-height: calc(100vh - 120px);
        }
        .dropdown-menu {
            z-index: 10 !important;
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
                    <a href="${createLink(controller: 'user', action: 'profile', id: session.user?.id)}" class="text-decoration-none text-dark me-2">
                        ${session.user?.username}
                    </a>
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
    <div class="container main-content mb-4">
        <div class="row">
            <!-- Left Sidebar -->
            <div class="col-md-5">
                <!-- User Profile Card -->
                <div class="content-card">
                    <div class="content-body">
                        <div class="d-flex align-items-center p-2">
                            <a href="${createLink(controller: 'user', action: 'profile', id: session.user.id)}">
                                <img src="${createLink(controller: 'user', action: 'photo', id: session.user.id)}"
                                     onerror="this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                                     class="profile-image me-3" alt="Profile" width="30">
                            </a>

                            <div>
                                <h4><strong>${session.user.firstName} ${session.user.lastName}</strong></h4>

                                <a href="${createLink(controller: 'user', action: 'profile', id: session.user.id)}" class="text-decoration-none">
                                    <p class="mb-2">${"@"+session.user.username}</p>
                                </a>

                                <div class="d-flex mt-2">
                                    <div class="me-4 text-center">
                                        <div><strong>
                                            <g:link controller="user" action="mySubscriptions" class="text-decoration-none text-dark">
                                                Subscription
                                            </g:link>
                                        </strong></div>
                                        <div>
                                            <g:link controller="user" action="mySubscriptions" class="text-decoration-none text-dark">
                                                ${subscriptionCount}
                                            </g:link>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                        <div><strong>
                                            <g:link controller="user" action="myTopics" class="text-decoration-none text-dark">
                                                Topics
                                            </g:link>
                                        </strong></div>
                                        <div>
                                            <g:link controller="user" action="myTopics" class="text-decoration-none text-dark">
                                                ${topics?.size() ?: 0}
                                            </g:link>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Subscriptions Card -->
                <div class="content-card">
                    <div class="content-header">
                        <span>Subscriptions</span>
                    </div>
                    <div class="content-body">
                        <div id="subscriptions-section">
                            <g:render template="/user/subscription" model="[subscriptions: subscriptions]" />
                        </div>
                    </div>
                </div>

                <!-- Trending Topics Card -->
                <div class="content-card">
                    <div class="content-header">
                        <span>Trending Topics</span>
                    </div>
                    <div class="content-body" id="trending-topics-section">
                        <g:render template="/user/refreshTopics" model="[trendingTopics: trendingTopics]" />
                    </div>
                </div>

            </div>

            <!-- Right Content Area -->
            <div class="col-md-7">
                <div class="content-card">
                    <div class="content-header">
                        <span>Inbox</span>
                        <form onsubmit="event.preventDefault(); searchInbox();" class="d-flex" style="max-width: 250px;">
                            <div class="input-group input-group-sm w-100">
                                <input type="text" id="inboxSearch" class="form-control" placeholder="Search">
                                <button type="submit" class="btn btn-dark">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                    <div class="content-body p-0">
                        <div id="inbox-section">
                            <g:render template="/user/inbox" model="[inboxItem: inboxItem]" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
                                <g:each in="${com.example.Subscription.findAllByUser(session.user)}" var="sub">
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


    <script>
    function refreshSection(url, containerId) {
        fetch(url)
            .then(res => {
                if (!res || !res.ok) {
                    throw new Error(`HTTP error! Status: ${res ? res.status : 'No response'}`);
                }
                return res.text();
            })
            .then(html => {
                const container = document.getElementById(containerId);
                if (container) {
                    container.innerHTML = html;
                } else {
                    console.warn(`Container ${containerId} not found`);
                }
            })
            .catch(error => console.error(`Error refreshing ${url}:`, error));
    }

    // Refresh all sections
    function refreshAll() {
        try {
            refreshSection('/user/refreshSubscriptions', 'subscriptions-section');
            refreshSection('/user/refreshTopics', 'trending-topics-section');
            refreshSection('/user/refreshInbox', 'inbox-section');
        } catch (error) {
            console.error('Error refreshing sections:', error);
        }
    }

    // Search inbox with debounce
    let searchTimeout;
    function searchInbox() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            try {
                const query = document.getElementById("inboxSearch").value;
                const encodedQuery = encodeURIComponent(query);
                refreshSection('/user/refreshInbox?search=' + encodedQuery, 'inbox-section');
            } catch (error) {
                console.error('Error searching inbox:', error);
            }
        }, 300);
    }
    
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
                
                // Refresh relevant sections
                refreshAll();
                
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
            // Set up event listeners for subscribe/unsubscribe buttons
            document.body.addEventListener('click', function(e) {
                const btn = e.target.closest('.subscribe-btn');
                if (!btn) return;
                
                e.preventDefault();
                const topicId = btn.dataset.topicId;
                if (btn.textContent.trim() === 'Subscribe') {
                    ajaxSubscribe(topicId, btn);
                } else if (btn.textContent.trim() === 'Unsubscribe') {
                    ajaxUnsubscribe(topicId, btn);
                }
            });

            document.getElementById('createTopicBtn').addEventListener('click', createTopic);
            document.getElementById('sendInviteBtn').addEventListener('click', sendInvitation);

            refreshAll();
        } catch (error) {
            console.error('Error in DOM load handler:', error);
        }
    });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <asset:javascript src="subscription.js"/>
</body>
</html>
