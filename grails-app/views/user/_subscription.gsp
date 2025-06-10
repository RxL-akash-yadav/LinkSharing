<%@ page import="com.example.Subscription" %>
<div class="content-body p-0">
    <g:if test="${!subscriptions || subscriptions.size() == 0}">
        <div class="p-3 text-muted">No subscriptions found.</div>
    </g:if>
    <g:else>
        <g:each in="${subscriptions}" var="sub">
            <div class="post-item mb-3" id="topic-${sub.topic.id}">
                <div class="d-flex gap-3">
                    <a href="${createLink(controller: 'user', action: 'profile', id: sub.topic.createdBy.id)}" class="flex-shrink-0">
                        <img src="${createLink(controller: 'user', action: 'photo', id: sub.topic.createdBy.id)}"
                             onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                             alt="User Profile" class="rounded-circle" width="60" height="60" style="object-fit: cover;" />
                    </a>
                    <div class="flex-grow-1">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <a href="${createLink(controller: 'resource', action: 'topic', id: sub.topic.id)}" class="fw-bold text-decoration-none">
                                ${sub.topic.name}
                            </a>
                            <span class="badge bg-light text-dark">${sub.topic.visibility}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                            <a href="${createLink(controller: 'user', action: 'profile', id: sub.topic.createdBy.id)}" class="text-decoration-none text-muted">
                                @${sub.topic.createdBy?.username}
                            </a>
                            <span>
                                <span class="me-2">Subscriptions: <b>${sub.topic.subscriptions?.size() ?: 0}</b></span>
                                <span>Posts: <b>${sub.topic.resources?.size() ?: 0}</b></span>
                            </span>
                        </div>
                        <div class="d-flex align-items-center gap-2 flex-wrap mt-2">
                            <g:set var="isSubscribed" value="${Subscription.findByUserAndTopic(session.user, sub.topic) != null}" />
                            <div class="d-flex align-items-center gap-2 flex-grow-1">
                                <g:if test="${isSubscribed}">
                                    <button class="btn btn-sm btn-outline-danger subscribe-btn" data-topic-id="${sub.topic.id}">Unsubscribe</button>
                                </g:if>
                                <g:else>
                                    <button class="btn btn-sm btn-outline-primary subscribe-btn" data-topic-id="${sub.topic.id}">Subscribe</button>
                                </g:else>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </g:each>
    </g:else>
</div>
<script>
function reloadSubscriptions() {
    fetch('/user/refreshSubscriptions')
        .then(res => res.text())
        .then(html => {
            document.getElementById('subscriptions-section').innerHTML = html;
        });
}
function reloadTrendingTopics() {
    fetch('/user/refreshTopics')
        .then(res => res.text())
        .then(html => {
            document.getElementById('trending-topics-section').innerHTML = html;
        });
}
function ajaxSubscribe(topicId, btn) {
    fetch('/user/ajaxSubscribe?topicId=' + topicId, {method: 'POST'})
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                btn.classList.remove('btn-outline-primary');
                btn.classList.add('btn-outline-danger');
                btn.textContent = 'Unsubscribe';
                btn.onclick = function() { ajaxUnsubscribe(topicId, btn); };
                reloadSubscriptions();
                reloadTrendingTopics();
            } else {
                alert(data.message);
            }
        });
}
function ajaxUnsubscribe(topicId, btn) {
    fetch('/user/ajaxUnsubscribe?topicId=' + topicId, {method: 'POST'})
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                btn.classList.remove('btn-outline-danger');
                btn.classList.add('btn-outline-primary');
                btn.textContent = 'Subscribe';
                btn.onclick = function() { ajaxSubscribe(topicId, btn); };
                reloadSubscriptions();
                reloadTrendingTopics();
            } else {
                alert(data.message);
            }
        });
}

// Removed deleteError topic function and event listeners
</script>

<!-- Removed invite modal -->
