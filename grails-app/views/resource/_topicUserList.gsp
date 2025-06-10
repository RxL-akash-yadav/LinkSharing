<div class="content-card">
    <div class="content-header">
        Users: "${topic.name}"
    </div>
    <div class="content-body p-0">
        <g:each in="${users}" var="user" status="i">
            <div class="post-item d-flex gap-3 ${i < users.size() - 1 ? 'border-bottom' : ''}">
                <a href="${createLink(controller: 'user', action: 'profile', id: user.id)}" class="flex-shrink-0">
                    <img src="${createLink(controller: 'user', action: 'photo', id: user.id)}"
                         onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                         alt="User Profile" class="rounded-circle" width="60" height="60" style="object-fit: cover;" />
                </a>
                <div class="flex-grow-1">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="mb-0 fw-bold">${user.firstName} ${user.lastName}</p>
                            <p class="text-muted mb-1">
                                @<g:link controller="user" action="profile" id="${user.id}" class="text-decoration-none text-muted">${user.username}</g:link>
                            </p>
                        </div>
                    </div>
                    <div class="d-flex mt-1">
                        <span class="me-3">Subscriptions: <span class="fw-bold">${user.subscriptions?.size() ?: 0}</span></span>
                        <span>Topics: <span class="fw-bold">${user.resources?.collect { it.topic }?.unique()?.size() ?: 0}</span></span>
                    </div>
                </div>
            </div>
        </g:each>
    </div>
    <% 
        int currentOffset = offset ?: 0
        int maxPerPage = max ?: 5
        int totalUsersCount = totalUsers ?: 0
        int totalPages = (totalUsersCount / maxPerPage) + ((totalUsersCount % maxPerPage) > 0 ? 1 : 0)
        int currentPage = (currentOffset / maxPerPage) + 1
    %>
    <g:if test="${totalPages > 1}">
        <div class="m-1 d-flex justify-content-end">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <button class="page-link user-page-link"
                                ${currentPage == 1 ? 'disabled' : ''}
                                onclick="loadUsers(${currentOffset - maxPerPage})">
                            Previous
                        </button>
                    </li>
                    <g:each in="${(1..totalPages)}" var="pageNum">
                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                            <button class="page-link user-page-link" onclick="loadUsers(${(pageNum - 1) * maxPerPage})">
                                ${pageNum}
                            </button>
                        </li>
                    </g:each>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <button class="page-link user-page-link"
                                ${currentPage == totalPages ? 'disabled' : ''}
                                onclick="loadUsers(${currentOffset + maxPerPage})">
                            Next
                        </button>
                    </li>
                </ul>
            </nav>
        </div>
    </g:if>
</div>