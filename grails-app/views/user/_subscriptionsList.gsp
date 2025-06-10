<%@ page import="com.example.Subscription" %>
<%@ page import="com.example.Topic" %>
<%@ page import="com.example.Visibility" %>
<%@ page import="com.example.Seriousness" %>

<div class="content-body p-0">
    <g:if test="${!subscriptionsList || subscriptionsList.size() == 0}">
        <div class="p-3 text-muted">No subscriptions found.</div>
    </g:if>
    <g:else>
        <ul class="list-group list-group-flush">
            <g:each var="sub" in="${subscriptionsList}">
                <li class="list-group-item px-3 py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <g:link controller="resource" action="topic" id="${sub.topic.id}" class="fw-bold text-decoration-none">
                            ${sub.topic.name}
                        </g:link>
                        <div>
                            <span class="badge bg-light text-dark me-2">
                                Subscriptions: <span class="subscription-count-${sub.topic.id}">${sub.topic.subscriptions?.size() ?: 0}</span>
                            </span>
                            <span class="badge bg-light text-dark">
                                Posts: ${sub.topic.resources?.size() ?: 0}
                            </span>
                        </div>
                    </div>
                    <div class="mt-2 d-flex align-items-center gap-2 flex-wrap">

                        
                        <g:if test="${Subscription.findByUserAndTopic(session.user, sub.topic)}">
                            <div class="seriousness-container d-flex align-items-center">
                                <select name="seriousness" class="form-select form-select-sm w-auto d-inline-block me-2 seriousness-select"
                                        id="seriousness-${sub.id}"
                                        data-topic-id="${sub.topic.id}" 
                                        data-subscription-id="${sub.id}" 
                                        data-original-value="${sub?.seriousness?.name()}">
                                    <g:each var="s" in="${Seriousness.values()}">
                                        <option value="${s.name()}" ${sub?.seriousness?.name() == s.name() ? 'selected' : ''}>${s.name().capitalize().replace('_', ' ')}</option>
                                    </g:each>
                                </select>
                                <button type="button" class="btn btn-sm btn-primary save-seriousness-btn" 
                                        data-subscription-id="${sub.id}">
                                    <i class="fas fa-save"></i> Save
                                </button>
                                <span class="seriousness-status ms-2"></span>
                            </div>
                            <div class="ms-auto">
                                <button type="button" class="btn btn-sm btn-outline-secondary"
                                        data-bs-toggle="modal"
                                        data-bs-target="#invitationModal"
                                        data-topic-id="${sub.topic.id}"
                                        data-topic-name="${sub.topic.name}">
                                    Invite
                                </button>
                            </div>
                        </g:if>
                        <g:else>
                            <button type="button" class="btn btn-sm btn-outline-primary subscribe-btn"
                                    data-topic-id="${sub.topic.id}">
                                Subscribe
                            </button>
                        </g:else>
                    </div>
                </li>
            </g:each>
        </ul>
    </g:else>
</div>
<% 
    def safeOffset = offset ?: 0
    def safeMax = max ?: 2
    def safeCount = subscriptionCount ?: 0

    int currentOffset = safeOffset as Integer
    int maxPerPage = safeMax as Integer
    int totalCount = safeCount as Integer

    int totalPages = totalCount > 0 ? Math.ceil(totalCount / maxPerPage) as Integer : 1
    int currentPage = (currentOffset / maxPerPage) + 1
%>
<div class="card-footer text-end mb-3">
    <nav aria-label="Page navigation">
        <ul class="pagination pagination-sm justify-content-end mb-0">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <button class="page-link" onclick="loadSubscriptions(${currentOffset - maxPerPage})">Previous</button>
            </li>
            <g:each in="${(1..totalPages)}" var="pageNum">
                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                    <button class="page-link" onclick="loadSubscriptions(${(pageNum - 1) * maxPerPage})">${pageNum}</button>
                </li>
            </g:each>
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <button class="page-link" onclick="loadSubscriptions(${currentOffset + maxPerPage})">Next</button>
            </li>
        </ul>
    </nav>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Add event listener for subscribe buttons only
        document.querySelectorAll('.subscribe-btn').forEach(button => {
            button.addEventListener('click', function() {
                const topicId = this.getAttribute('data-topic-id');
                ajaxSubscribeHandler(topicId, this);
            });
        });

        // Event listener for save seriousness buttons
        document.querySelectorAll('.save-seriousness-btn').forEach(button => {
            button.addEventListener('click', function() {
                const subscriptionId = this.getAttribute('data-subscription-id');
                const selectElement = document.getElementById('seriousness-' + subscriptionId);
                const seriousness = selectElement.value;
                const originalValue = selectElement.getAttribute('data-original-value');
                const statusElement = this.parentElement.querySelector('.seriousness-status');
                
                // Debug to see if the event handler is triggering
                console.log('Save button clicked for subscription:', subscriptionId);
                console.log('Selected seriousness:', seriousness);
                
                // Disable button and show loading state
                this.disabled = true;
                this.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';
                
                // Disable select during the update
                selectElement.disabled = true;
                
                updateSeriousness(subscriptionId, seriousness, selectElement, statusElement, originalValue, this);
            });
        });

        // Visibility change
        document.body.addEventListener('change', function(e) {
            if (e.target && e.target.classList.contains('visibility-select')) {
                const topicId = e.target.getAttribute('data-topic-id');
                const visibility = e.target.value;
                fetch('/topic/updateVisibility', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: JSON.stringify({ id: topicId, visibility: visibility })
                })
                .then(res => res.json())
                .then(data => {
                    if (!data.success) {
                        alert(data.error || 'Failed to update visibility');
                    }
                })
                .catch(() => alert('Failed to update visibility'));
            }
        });
    });
    
    // Function for updating seriousness with proper feedback
    function updateSeriousness(subscriptionId, seriousness, selectElement, statusElement, originalValue, buttonElement) {
        // Debug - log the function call
        console.log('updateSeriousness called with:', subscriptionId, seriousness);
        
        // Use a simpler approach for the URL to avoid GSP evaluation issues
        const url = window.location.origin + '/subscription/updateSeriousness';
        console.log('Request URL:', url);
        
        // First convert to FormData for easier debugging
        const formData = new FormData();
        formData.append('id', subscriptionId);
        formData.append('seriousness', seriousness);
        
        // Send as regular form POST instead of JSON
        fetch(url, {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            },
            credentials: 'same-origin'
        })
        .then(response => {
            console.log('Response status:', response.status);
            if (!response.ok) {
                return response.text().then(text => {
                    console.error('Response text:', text);
                    throw new Error('Server returned ' + response.status);
                });
            }
            return response.json();
        })
        .then(data => {
            console.log('Response data:', data);
            selectElement.disabled = false;
            
            // Re-enable button and restore original text
            buttonElement.disabled = false;
            buttonElement.innerHTML = '<i class="fas fa-save"></i> Save';
            
            if (data.success) {
                // Update data-original-value attribute
                selectElement.setAttribute('data-original-value', seriousness);
                
                // Show success status
                statusElement.className = 'seriousness-status ms-2 text-success';
                statusElement.innerHTML = '<i class="fas fa-check"></i> Saved';
                
                // Fade out the status message after 2 seconds
                setTimeout(() => {
                    statusElement.style.transition = 'opacity 0.5s';
                    statusElement.style.opacity = '0';
                    setTimeout(() => {
                        statusElement.innerHTML = '';
                        statusElement.className = 'seriousness-status ms-2';
                        statusElement.style.opacity = '1';
                    }, 500);
                }, 2000);
                
                // Show notification if function exists
                if (typeof showNotification === 'function') {
                    showNotification('Seriousness updated successfully', 'success');
                }
            } else {
                // Show error and revert to original value
                selectElement.value = originalValue;
                statusElement.className = 'seriousness-status ms-2 text-danger';
                statusElement.innerHTML = '<i class="fas fa-times"></i> Failed: ' + (data.error || 'Unknown error');
                
                // Show error notification if function exists
                if (typeof showNotification === 'function') {
                    showNotification(data.error || 'Failed to update seriousness', 'danger');
                }
                
                setTimeout(() => {
                    statusElement.innerHTML = '';
                    statusElement.className = 'seriousness-status ms-2';
                }, 3000);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            selectElement.disabled = false;
            selectElement.value = originalValue;
            
            // Re-enable button and restore original text
            buttonElement.disabled = false;
            buttonElement.innerHTML = '<i class="fas fa-save"></i> Save';
            
            // Show error status
            statusElement.className = 'seriousness-status ms-2 text-danger';
            statusElement.innerHTML = '<i class="fas fa-times"></i> Error: ' + error.message;
            
            // Show error notification if function exists
            if (typeof showNotification === 'function') {
                showNotification('Error updating seriousness: ' + error.message, 'danger');
            }
            
            setTimeout(() => {
                statusElement.innerHTML = '';
                statusElement.className = 'seriousness-status ms-2';
            }, 3000);
        });
    }
    
    // Function for handling subscribe with loading state
    function ajaxSubscribeHandler(topicId, btn) {
        // Disable button and show loading state
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Subscribing...';
        
        fetch('/user/ajaxSubscribe?topicId=' + topicId, {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Accept': 'application/json'
            }
        })
        .then(response => {
            if (!response.ok) throw new Error('Failed to subscribe');
            return response.json();
        })
        .then(data => {
            if