<%@ page import="com.example.Subscription" %>
<%@ page import="com.example.Topic" %>
<%@ page import="com.example.Visibility" %>
<%@ page import="com.example.Seriousness" %>

<ul class="list-group list-group-flush border-bottom" id="profile-topics-section">
    <g:each var="topic" in="${topics}">
        <li class="list-group-item">
            <div class="d-flex justify-content-between align-items-center">
                <g:link controller="resource" action="topic" id="${topic.id}" class="text-decoration-none">
                    ${topic.name}
                </g:link>
                <div>
                    <span class="badge bg-light text-dark me-2">
                        Subscriptions: ${topic.subscriptions?.size() ?: 0}
                    </span>
                    <span class="badge bg-light text-dark">
                        Posts: ${topic.resources?.size() ?: 0}
                    </span>
                </div>
            </div>
            <div class="mt-2 d-flex align-items-center">

                <g:set var="currentSubscription" value="${Subscription.findByUserAndTopic(session.user, topic)}" />
                <g:if test="${currentSubscription}">
                    <button type="button" class="btn btn-sm btn-outline-danger unsubscribe-btn me-2"
                            data-topic-id="${topic.id}" onclick="ajaxUnsubscribe('${topic.id}', this)">
                        Unsubscribe
                    </button>
                </g:if>
                <g:else>
                    <button type="button" class="btn btn-sm btn-outline-success subscribe-btn me-2"
                            data-topic-id="${topic.id}" onclick="ajaxSubscribe('${topic.id}', this)">
                        Subscribe
                    </button>
                </g:else>
                <g:if test="${currentSubscription}">
                    <div class="ms-auto">
                        <button type="button" class="btn btn-sm btn-outline-secondary"
                                data-bs-toggle="modal"
                                data-bs-target="#invitationModal"
                                data-topic-id="${topic.id}"
                                data-topic-name="${topic.name}">
                            Invite
                        </button>
                    </div>
                </g:if>
            </div>
        </li>
    </g:each>
</ul>

<!-- Pagination -->
<%
    int currentOffset = offset ?: 0
    int maxPerPage = max ?: 5
    int totalPages = (topicCount / maxPerPage) + ((topicCount % maxPerPage) > 0 ? 1 : 0)
    int currentPage = (currentOffset / maxPerPage) + 1
%>

<div class="m-1 d-flex justify-content-end">
    <nav aria-label="Page navigation">
        <ul class="pagination">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <button class="page-link" onclick="loadTopics(${currentOffset - maxPerPage})" ${currentPage == 1 ? 'disabled' : ''}>Previous</button>
            </li>

            <g:each in="${(1..totalPages)}" var="pageNum">
                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                    <button class="page-link" onclick="loadTopics(${(pageNum - 1) * maxPerPage})">${pageNum}</button>
                </li>
            </g:each>

            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <button class="page-link" onclick="loadTopics(${currentOffset + maxPerPage})" ${currentPage == totalPages ? 'disabled' : ''}>Next</button>
            </li>
        </ul>
    </nav>
</div>
