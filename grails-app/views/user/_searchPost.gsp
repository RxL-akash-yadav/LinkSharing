<%@ page import="com.example.Subscription" %>

<g:if test="${!search || search.empty}">
    <div class="alert alert-info m-3">No results found for "${q}". Try a different search term.</div>
</g:if>
<g:else>
    <div class="mb-2 px-3 pt-2">
        <small class="text-muted">Found ${searchCount} result(s) for "${q}"</small>
    </div>
    
    <g:each in="${search}" var="resource">
        <div class="post-item">
            <div class="d-flex gap-3">
                <a href="${createLink(controller: 'user', action: 'profile', id: resource.createdBy.id)}" class="flex-shrink-0">
                    <img src="${createLink(controller: 'user', action: 'photo', id: resource.createdBy.id)}"
                         onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                         class="rounded-circle" width="70" height="70" style="object-fit: cover;" />
                </a>
                <div class="flex-grow-1">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <strong>${resource.createdBy.firstName} ${resource.createdBy.lastName}</strong>
                        <a href="${createLink(controller: 'resource', action: 'topic', id: resource.topic.id)}" class="text-decoration-none badge bg-light text-dark">
                            ${resource.topic.name}
                        </a>
                    </div>
                    <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                        <a href="${createLink(controller: 'user', action: 'profile', id: resource.createdBy.id)}" class="text-decoration-none text-muted">
                            @${resource.createdBy.username}
                        </a>
                        <g:formatDate date="${resource.dateCreated}" format="dd MMM yyyy, hh:mm a"/>
                    </div>
                    <p class="mb-2">${resource.description}</p>
                    <div class="d-flex justify-content-between mt-2">
                        <div>
                            <a href="https://twitter.com/intent/tweet?text=${resource.description?.encodeAsURL()}&url=${createLink(controller: 'resource', action: 'post', id: resource.id, absolute: true)}"
                               class="btn btn-sm btn-outline-primary me-1" target="_blank" rel="noopener">
                                <i class="fab fa-twitter"></i> Tweet
                            </a>
                            <a href="https://www.facebook.com/sharer/sharer.php?u=${createLink(controller: 'resource', action: 'post', id: resource.id, absolute: true)}"
                               class="btn btn-sm btn-outline-primary" target="_blank" rel="noopener">
                                <i class="fab fa-facebook"></i> Share
                            </a>
                        </div>
                        <div>

                            
                            <g:if test="${resource instanceof com.example.DocumentResource}">
                                <a href="/resource/download/${resource.id}" class="btn btn-outline-success btn-sm me-2">Download</a>
                            </g:if>
                            <g:elseif test="${resource instanceof com.example.LinkResource}">
                                <a href="${resource.url}" class="btn btn-outline-success btn-sm me-2" target="_blank">View full site</a>
                            </g:elseif>
                            <g:link controller="resource" action="post" id="${resource.id}" class="btn btn-outline-primary btn-sm">View post</g:link>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </g:each>
</g:else>
