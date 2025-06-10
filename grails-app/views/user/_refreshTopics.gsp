<%@ page import="com.example.Subscription" %>
<div class="content-body p-0">
    <g:if test="${!trendingTopics || trendingTopics.size() == 0}">
        <div class="p-3 text-muted">No trending topics found.</div>
    </g:if>
    <g:else>
        <g:each in="${trendingTopics}" var="topic">
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
                                    <button class="btn btn-sm btn-outline-danger subscribe-btn" data-topic-id="${topic.id}">Unsubscribe</button>
                                </g:if>
                                <g:else>
                                    <button class="btn btn-sm btn-outline-primary subscribe-btn" data-topic-id="${topic.id}">Subscribe</button>
                                </g:else>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </g:each>
    </g:else>
</div>

<!-- Removed the invite modal and its related script -->
<script>
document.addEventListener('DOMContentLoaded', function () {
    // Delete topic via AJAX - removed
    
    // Removed event listeners for edit/delete buttons and invite modal
});
</script>
