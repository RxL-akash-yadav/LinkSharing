<%@ page import="com.example.Subscription" %>
<%@ page import="com.example.Visibility" %>

<g:if test="${!trendingTopics || trendingTopics.empty}">
    <div class="alert alert-info m-3">No trending topics available.</div>
</g:if>
<g:else>
    <g:each in="${trendingTopics}" var="topic" status="idx">
        <div class="post-item mb-3" id="topic-${topic.id}">
            <div class="d-flex gap-3">
                <a href="${createLink(controller: 'user', action: 'profile', id: topic.createdBy.id)}" class="flex-shrink-0">
                    <img src="${createLink(controller: 'user', action: 'photo', id: topic.createdBy.id)}"
                         onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                         alt="User Profile" class="rounded-circle" width="60" height="60" style="object-fit: cover;" />
                </a>
                <div class="flex-grow-1">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <a href="${createLink(controller: 'resource', action: 'topic', id: topic.id)}" class="fw-bold text-decoration-none">
                            ${topic.name}
                        </a>
                        <span class="badge bg-light text-dark">${topic.visibility}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                        <a href="${createLink(controller: 'user', action: 'profile', id: topic.createdBy.id)}" class="text-decoration-none text-muted">
                            @${topic.createdBy?.username}
                        </a>
                        <span>
                            <span class="me-2">Subscriptions: <b>${topic.subscriptions?.size() ?: 0}</b></span>
                            <span>Posts: <b>${topic.resources?.size() ?: 0}</b></span>
                        </span>
                    </div>
                    <div class="d-flex align-items-center gap-2 flex-wrap mt-2">
                        <g:set var="isSubscribed" value="${Subscription.findByUserAndTopic(session.user, topic) != null}" />
                        <div class="d-flex align-items-center gap-2 flex-grow-1">
                            <g:if test="${isSubscribed}">
                                <button class="btn btn-sm btn-outline-danger subscribe-btn" 
                                        data-topic-id="${topic.id}">Unsubscribe</button>
                            </g:if>
                            <g:else>
                                <button class="btn btn-sm btn-outline-primary subscribe-btn" 
                                        data-topic-id="${topic.id}">Subscribe</button>
                            </g:else>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </g:each>
</g:else>

<script>
// Fix for subscription handling that uses the same approach as dashboard
document.addEventListener('DOMContentLoaded', function() {
    const buttons = document.querySelectorAll('.subscribe-btn');
    buttons.forEach(btn => {
        btn.addEventListener('click', function() {
            const topicId = this.getAttribute('data-topic-id');
            if (this.textContent.trim() === 'Subscribe') {
                ajaxSubscribe(topicId, this);
            } else {
                ajaxUnsubscribe(topicId, this);
            }
        });
    });
});

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
            
            // Show success notification if function exists
            if (typeof showNotification === 'function') {
                showNotification('Subscribed successfully', 'success');
            }
            
            // Refresh trending topics
            if (typeof loadTrendingTopics === 'function') {
                loadTrendingTopics();
            }
        } else {
            if (typeof showNotification === 'function') {
                showNotification(data.message || 'Failed to subscribe', 'danger');
            } else {
                alert(data.message || 'Failed to subscribe');
            }
        }
    })
    .catch(error => {
        console.error('Error subscribing:', error);
        if (typeof showNotification === 'function') {
            showNotification('Failed to subscribe. Please try again.', 'danger');
        } else {
            alert('Failed to subscribe. Please try again.');
        }
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
            
            // Show success notification if function exists
            if (typeof showNotification === 'function') {
                showNotification('Unsubscribed successfully', 'success');
            }
            
            // Refresh trending topics
            if (typeof loadTrendingTopics === 'function') {
                loadTrendingTopics();
            }
        } else {
            if (typeof showNotification === 'function') {
                showNotification(data.message || 'Failed to unsubscribe', 'danger');
            } else {
                alert(data.message || 'Failed to unsubscribe');
            }
        }
    })
    .catch(error => {
        console.error('Error unsubscribing:', error);
        if (typeof showNotification === 'function') {
            showNotification('Failed to unsubscribe. Please try again.', 'danger');
        } else {
            alert('Failed to unsubscribe. Please try again.');
        }
    });
}

// Add utility function for displaying notifications
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
