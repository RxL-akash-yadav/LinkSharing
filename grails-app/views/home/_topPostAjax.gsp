<g:if test="${!topPost || topPost.empty}">
    <div class="alert alert-info">No top posts available for the selected timeframe.</div>
</g:if>
<g:else>
    <g:each in="${topPost}" var="resource">
        <div class="post-item mb-3">
            <div class="d-flex gap-3">
                <a href="${createLink(controller: 'user', action: 'profile', id: resource.createdBy.id)}" class="flex-shrink-0">
                    <img src="${createLink(controller: 'user', action: 'photo', id: resource.createdBy.id)}"
                         onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                         alt="User Profile" class="rounded-circle" width="70" height="70" style="object-fit: cover;" />
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
                        <g:formatDate date="${resource.dateCreated}" format="dd MMM yyyy, hh:mm a" />
                    </div>
                    <p class="mb-2">${resource.description}</p>
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
                            <a href="${createLink(controller: 'resource', action: 'post', id: resource.id)}" class="btn btn-sm btn-primary">
                                View Post
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </g:each>
</g:else>
