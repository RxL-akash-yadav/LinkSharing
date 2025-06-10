<%@ page import="com.example.Subscription" %>

<ul class="list-group list-group-flush">
    <g:if test="${!posts || posts.isEmpty()}">
        <li class="list-group-item text-center text-muted">No posts found.</li>
    </g:if>
    <g:each var="post" in="${posts}" status="idx">
        <li class="list-group-item px-0 py-2" style="border: none; background: transparent;">
            <div class="post-item mb-0" style="padding:10px;">
                <div class="d-flex gap-3">
                    <a href="${createLink(controller: 'user', action: 'profile', id: post.createdBy.id)}" class="flex-shrink-0">
                        <img src="${createLink(controller: 'user', action: 'photo', id: post.createdBy.id)}"
                             onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                             alt="User Profile" class="rounded-circle" width="70" height="70" style="object-fit: cover;" />
                    </a>
                    <div class="flex-grow-1">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <strong>${post.createdBy.firstName} ${post.createdBy.lastName}</strong>
                            <a href="${createLink(controller: 'resource', action: 'topic', id: post.topic.id)}" class="text-decoration-none badge bg-light text-dark">
                                ${post.topic.name}
                            </a>
                        </div>
                        <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                            <span>@${post.createdBy.username}</span>
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
                                    <a href="/resource/download/${post.id}" class="btn btn-sm btn-outline-secondary me-1">Download</a>
                                </g:if>
                                <g:elseif test="${post instanceof com.example.LinkResource}">
                                    <a href="${post.url}" class="btn btn-sm btn-outline-secondary me-1" target="_blank">View full site</a>
                                </g:elseif>
                                <g:link controller="resource" action="post" id="${post.id}" class="btn btn-sm btn-primary">View post</g:link>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <g:if test="${idx < posts.size() - 1}">
                <hr style="margin: 6px 0 0 0; border-top: 1px solid #eee;">
            </g:if>
        </li>
    </g:each>
</ul>

<!-- Pagination -->
<%
    int currentOffset = offset ?: 0
    int maxPerPage = max ?: 20
    int totalCount = postCount ?: 0
    int totalPages = totalCount > 0 ? (totalCount / maxPerPage) + ((totalCount % maxPerPage) > 0 ? 1 : 0) : 1
    int currentPage = (currentOffset / maxPerPage) + 1
%>

<div class="m-1 d-flex justify-content-end">
    <nav aria-label="Page navigation">
        <ul class="pagination">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <button class="page-link" onclick="loadPosts(${Math.max(0, currentOffset - maxPerPage)})">Previous</button>
            </li>
            <g:each in="${(1..totalPages)}" var="pageNum">
                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                    <button class="page-link" onclick="loadPosts(${(pageNum - 1) * maxPerPage})">${pageNum}</button>
                </li>
            </g:each>
            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                <button class="page-link" onclick="loadPosts(${currentOffset + maxPerPage})">Next</button>
            </li>
        </ul>
    </nav>
</div>