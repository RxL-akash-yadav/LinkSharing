<%@ page import="com.example.Subscription" %>
<g:if test="${!inboxItem || inboxItem.size() == 0}">
    <div class="p-3 text-muted">No inbox posts found.</div>
</g:if>
<g:else>
    <div id="inbox-container">
        <g:each in="${inboxItem}" var="post">
            <g:if test="${post != null && post?.createdBy && post?.topic}">
                <div class="post-item mb-3" id="post-${post.id}">
                    <div class="d-flex gap-3">
                        <a href="${createLink(controller: 'user', action: 'profile', id: post.createdBy.id)}" class="flex-shrink-0">
                            <img src="${createLink(controller: 'user', action: 'photo', id: post.createdBy.id)}"
                                 onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                                 alt="User Profile" class="rounded-circle" width="60" height="60" style="object-fit: cover;" />
                        </a>
                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <strong>${post.createdBy.firstName} ${post.createdBy.lastName}</strong>
                                <a href="${createLink(controller: 'resource', action: 'topic', id: post.topic.id)}" class="text-decoration-none badge bg-light text-dark">
                                    ${post.topic.name}
                                </a>
                            </div>
                            <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                                <a href="${createLink(controller: 'user', action: 'profile', id: post.createdBy.id)}" class="text-decoration-none text-muted">
                                    @${post.createdBy.username}
                                </a>
                                <g:formatDate date="${post.dateCreated}" format="dd MMM yyyy, hh:mm a" />
                            </div>
                            <p class="mb-2">${post.description}</p>
                            <div class="d-flex justify-content-between mt-2">
                                <div>
                                    <a href="#" class="btn btn-sm btn-outline-primary me-1">
                                        <i class="fab fa-twitter"></i> Share
                                    </a>
                                    <a href="#" class="btn btn-sm btn-outline-primary">
                                        <i class="fab fa-facebook"></i> Share
                                    </a>
                                </div>
                                <div>
                                    <g:if test="${post instanceof com.example.DocumentResource}">
                                        <button onclick="downloadDocument(${post.id})" class="btn btn-sm btn-outline-secondary me-1 download-btn" id="download-${post.id}">Download</button>
                                    </g:if>
                                    <g:elseif test="${post instanceof com.example.LinkResource}">
                                        <a href="${post.url}" class="btn btn-sm btn-outline-secondary me-1" target="_blank">View full site</a>
                                    </g:elseif>
                                    <button onclick="markAsRead(${post.id})" class="btn btn-sm btn-outline-success me-1 mark-read-btn" id="mark-read-${post.id}">Mark as read</button>
                                    <g:link controller="resource" action="post" id="${post.id}" class="btn btn-sm btn-primary">View Post</g:link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </g:if>
        </g:each>
    </div>

    <!-- Pagination -->
    <%
        int currentOffset = offset ?: 0
        int maxPerPage = max ?: 20
        int totalCount = inboxCount ?: 0
        int totalPages = totalCount > 0 ? (totalCount / maxPerPage) + ((totalCount % maxPerPage) > 0 ? 1 : 0) : 1
        int currentPage = (currentOffset / maxPerPage) + 1
    %>

    <div class="m-1 d-flex justify-content-end">
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <button class="page-link" onclick="loadInbox(${Math.max(0, currentOffset - maxPerPage)})">Previous</button>
                </li>
                <g:each in="${(1..totalPages)}" var="pageNum">
                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                        <button class="page-link" onclick="loadInbox(${(pageNum - 1) * maxPerPage})">${pageNum}</button>
                    </li>
                </g:each>
                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                    <button class="page-link" onclick="loadInbox(${currentOffset + maxPerPage})">Next</button>
                </li>
            </ul>
        </nav>
    </div>

    <script>
        function markAsRead(resourceId) {
            const button = document.getElementById(`mark-read-${resourceId}`);
            if (!button) {
                console.error(`Button with ID mark-read-${resourceId} not found`);
                return;
            }
            
            button.disabled = true;
            button.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Marking...';
            
            // Fixed URL construction with absolute URL
            const url = '${createLink(controller: 'resource', action: 'markAsRead', absolute: true)}';
            
            fetch(url, {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ id: resourceId }),
                credentials: 'same-origin'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`Server returned error status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                if (data && data.success) {
                    // Update UI to show the post is read
                    button.classList.remove('btn-outline-success');
                    button.classList.add('btn-success');
                    button.innerHTML = '<i class="fas fa-check"></i> Read';
                    button.disabled = true;
                    
                    // Visual indicator for the post
                    const postItem = document.getElementById(`post-${resourceId}`);
                    if (postItem) {
                        postItem.style.opacity = '0.7';
                        postItem.style.backgroundColor = '#f8f9fa';
                        postItem.style.transition = 'all 0.5s';
                    }
                    
                    // Show success message
                    showFlashMessage('Post marked as read successfully', 'success');
                    
                    // Update unread count in navbar if it exists
                    updateUnreadCount();
                    
                    // Reload inbox after a short delay
                    setTimeout(() => {
                        reloadInbox();
                    }, 1000);
                } else {
                    // Show error and reset button
                    button.disabled = false;
                    button.innerHTML = 'Mark as read';
                    showFlashMessage(data?.error || 'Failed to mark as read', 'danger');
                }
            })
            .catch(error => {
                console.error('Error marking as read:', error);
                button.disabled = false;
                button.innerHTML = 'Mark as read';
                showFlashMessage('Error: ' + (error?.message || 'Unknown error occurred'), 'danger');
            });
        }
        
        // Helper function to update unread count in navbar
        function updateUnreadCount() {
            const unreadCountElement = document.getElementById('unread-count');
            if (unreadCountElement) {
                const currentCount = parseInt(unreadCountElement.textContent);
                if (!isNaN(currentCount) && currentCount > 0) {
                    unreadCountElement.textContent = currentCount - 1;
                    // If count reaches zero, you might want to hide the badge
                    if (currentCount - 1 <= 0) {
                        unreadCountElement.style.display = 'none';
                    }
                }
            }
        }
        
        // Fixed function to handle document downloads via AJAX
        function downloadDocument(resourceId) {
            // Disable button to prevent multiple clicks
            const button = document.getElementById(`download-${resourceId}`);
            if (!button) {
                console.error(`Button with ID download-${resourceId} not found`);
                return;
            }
            
            button.disabled = true;
            button.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Downloading...';
            
            // Make AJAX request to get download URL
            fetch('${createLink(controller: 'resource', action: 'download')}/' + resourceId, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`Server returned error status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                if (data && data.success) {
                    // Create a hidden iframe to trigger the download
                    const iframe = document.createElement('iframe');
                    iframe.style.display = 'none';
                    iframe.src = data.downloadUrl;
                    document.body.appendChild(iframe);
                    
                    // Show success message with safe access to fileName
                    const fileName = data.fileName || 'file';
                    showFlashMessage(`Downloading ${fileName}...`, 'success');
                    
                    // Remove iframe after a delay
                    setTimeout(() => {
                        document.body.removeChild(iframe);
                    }, 5000);
                    
                    // Mark as read automatically
                    markAsRead(resourceId);
                } else {
                    // Show error message
                    showFlashMessage(data?.error || 'Download failed', 'danger');
                }
                
                // Reset button
                button.disabled = false;
                button.innerHTML = 'Download';
            })
            .catch(error => {
                console.error('Error downloading document:', error);
                showFlashMessage('Error: ' + (error?.message || 'Unknown error occurred'), 'danger');
                
                // Reset button
                button.disabled = false;
                button.innerHTML = 'Download';
            });
        }
        
        // Function to load inbox content with pagination
        function loadInbox(offset) {
            const searchTerm = document.getElementById('searchBox') ? document.getElementById('searchBox').value : '';
            
            // Get the container element
            const container = document.querySelector('#inbox-container');
            if (!container || !container.parentElement) {
                console.error('Inbox container not found');
                return;
            }
            
            // Show loading indicator
            const containerParent = container.parentElement;
            const originalContent = containerParent.innerHTML;
            containerParent.innerHTML = `
                <div class="text-center p-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Loading inbox...</p>
                </div>
            `;
            
            // Make AJAX request
            fetch('${createLink(controller: 'user', action: 'inboxAjax')}?offset=' + offset + '&search=' + encodeURIComponent(searchTerm), {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load inbox: ' + response.status);
                }
                return response.text();
            })
            .then(html => {
                containerParent.innerHTML = html;
                
                // Re-initialize scripts
                const scripts = containerParent.querySelectorAll('script');
                scripts.forEach(oldScript => {
                    const newScript = document.createElement('script');
                    Array.from(oldScript.attributes).forEach(attr => {
                        newScript.setAttribute(attr.name, attr.value);
                    });
                    newScript.appendChild(document.createTextNode(oldScript.innerHTML));
                    oldScript.parentNode.replaceChild(newScript, oldScript);
                });
            })
            .catch(error => {
                console.error('Error loading inbox:', error);
                containerParent.innerHTML = `
                    <div class="alert alert-danger m-3">
                        Failed to load inbox: ${error?.message || 'Unknown error'}
                        <button onclick="reloadInbox()" class="btn btn-sm btn-outline-danger ms-2">Try Again</button>
                    </div>
                `;
                showFlashMessage('Failed to load inbox', 'danger');
            });
        }
        
        // Function to reload inbox at current offset
        function reloadInbox() {
            loadInbox(${currentOffset});
        }
        
        // Helper function to show flash messages
        function showFlashMessage(message, type) {
            // Find existing flash container or create one
            let flashContainer = document.querySelector('.flash-container');
            if (!flashContainer) {
                flashContainer = document.createElement('div');
                flashContainer.className = 'flash-container position-fixed top-0 start-50 translate-middle-x mt-3 z-index-1050';
                document.body.appendChild(flashContainer);
            }
            
            const alert = document.createElement('div');
            alert.className = `alert alert-${type} alert-dismissible fade show`;
            alert.innerHTML = `${message} <button type="button" class="btn-close" data-bs-dismiss="alert"></button>`;
            
            flashContainer.appendChild(alert);
            
            // Auto-dismiss after 3 seconds
            setTimeout(() => {
                alert.classList.remove('show');
                setTimeout(() => {
                    flashContainer.removeChild(alert);
                }, 500);
            }, 3000);
        }
    </script>
</g:else>