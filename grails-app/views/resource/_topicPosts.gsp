<g:if test="${posts && posts.size() > 0}">
    <g:each in="${posts}" var="res" status="i">
        <div class="post-item mb-3">
            <div class="d-flex gap-3">
                <a href="${createLink(controller: 'user', action: 'profile', id: res.createdBy.id)}" class="flex-shrink-0">
                    <img src="${createLink(controller: 'user', action: 'photo', id: res.createdBy.id)}"
                         onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                         alt="User Profile" class="rounded-circle" width="70" height="70" style="object-fit: cover;" />
                </a>
                <div class="flex-grow-1">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <strong>${res.createdBy.firstName} ${res.createdBy.lastName}</strong>
                        <a href="${createLink(controller: 'resource', action: 'topic', id: res.topic.id)}" class="text-decoration-none badge bg-light text-dark">
                            ${res.topic.name}
                        </a>
                    </div>
                    <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                        <span>
                            @<g:link controller="user" action="profile" id="${res.createdBy.id}" class="text-decoration-none text-muted">${res.createdBy.username}</g:link>
                        </span>
                        <g:formatDate date="${res.dateCreated}" format="dd MMM yyyy, hh:mm a" />
                    </div>
                    <p class="mb-2">${res?.description?.encodeAsHTML()}</p>
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
                            <g:if test="${res instanceof com.example.DocumentResource}">
                                <a href="/resource/download/${res.id}" class="btn btn-sm btn-outline-secondary me-1">Download</a>
                            </g:if>
                            <g:elseif test="${res instanceof com.example.LinkResource}">
                                <a href="${res.url}" class="btn btn-sm btn-outline-secondary me-1" target="_blank">View full site</a>
                            </g:elseif>
                            <g:link controller="resource" action="post" id="${res.id}" class="btn btn-sm btn-primary">View Post</g:link>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </g:each>
    <g:if test="${totalCount > max}">
        <% 
            int currentOffset = offset ?: 0
            int maxPerPage = max ?: 5
            int totalCountSafe = totalCount ?: 0
            int totalPages = (totalCountSafe / maxPerPage) + ((totalCountSafe % maxPerPage) > 0 ? 1 : 0)
            int currentPage = (currentOffset / maxPerPage) + 1
        %>
        <div class="m-1 d-flex justify-content-end">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <button class="page-link" ${currentPage == 1 ? 'disabled' : ''}
                                onclick="loadPosts(${currentOffset - maxPerPage})">Previous</button>
                    </li>
                    <g:each in="${(1..totalPages)}" var="pageNum">
                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                            <button class="page-link" onclick="loadPosts(${(pageNum - 1) * maxPerPage})">${pageNum}</button>
                        </li>
                    </g:each>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <button class="page-link" ${currentPage == totalPages ? 'disabled' : ''}
                                onclick="loadPosts(${currentOffset + maxPerPage})">Next</button>
                    </li>
                </ul>
            </nav>
        </div>
    </g:if>
</g:if>
<g:else>
    <div class="p-3 text-muted">No posts found.</div>
</g:else>