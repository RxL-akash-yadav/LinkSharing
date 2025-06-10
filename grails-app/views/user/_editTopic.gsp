<%@ page import="com.example.Subscription" %>
<%@ page import="com.example.Topic" %>
<%@ page import="com.example.Visibility" %>
<%@ page import="com.example.Seriousness" %>
<g:if test="${topics != null && topics && topics.size() > 0}">
  <div>
    <g:each in="${topics}" var="topic" status="idx">
      <div class="post-item px-0 py-2" style="background:transparent;">
        <div class="d-flex gap-3">
          <a href="${createLink(controller: 'user', action: 'profile', id: topic.createdBy?.id)}" class="flex-shrink-0">
            <img src="${createLink(controller: 'user', action: 'photo', id: topic.createdBy?.id)}"
                 onerror="this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s';"
                 class="rounded-circle" alt="Profile" width="70" height="70" style="object-fit: cover;">
          </a>
          <div class="flex-grow-1">
            <div class="d-flex justify-content-between align-items-center mb-1">
              <!-- Topic name display and edit input -->
              <div style="flex:1;">
                <span id="topic-name-display-${topic.id}" style="display: block;">
                  <h6 class="mb-0 d-inline" style="font-size: 1rem;">
                    <a href="${createLink(controller: 'resource', action: 'topic', id: topic.id)}" class="text-decoration-none">
                      ${topic.name}
                    </a>
                  </h6>
                </span>
                <span id="topic-name-edit-${topic.id}" style="display: none;">
                  <input type="text" class="form-control form-control-sm d-inline w-auto" id="topic-name-input-${topic.id}" value="${topic.name?.encodeAsHTML()}" style="max-width:220px; display:inline-block;">
                  <button class="btn btn-sm btn-outline-secondary ms-1" type="button" onclick="saveTopicAjax(${topic.id})">Save</button>
                  <button class="btn btn-sm btn-outline-secondary ms-1" type="button" onclick="cancelEdit(${topic.id})">Cancel</button>
                </span>
              </div>
              <span class="badge bg-light text-dark">${topic.visibility}</span>
            </div>
            <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
              <span>
                <a href="${createLink(controller: 'user', action: 'profile', id: topic.createdBy?.id)}" class="text-decoration-none text-muted">
                  @${topic.createdBy?.username}
                </a>
              </span>
            </div>
            <div class="mb-2">
              <span class="badge bg-light text-dark me-2">Subscriptions: ${topic.subscriptionCount ?: (topic.subscriptions?.size() ?: 0)}</span>
              <span class="badge bg-light text-dark">Posts: ${topic.postCount ?: (topic.resources?.size() ?: 0)}</span>
            </div>
            <div class="d-flex justify-content-end align-items-center gap-2">
              <button class="btn btn-sm btn-outline-primary" onclick="debugToggleEdit(${topic.id})" id="edit-btn-${topic.id}">
                <i class="bi bi-pencil"></i> Edit
              </button>
              <a href="#" class="btn btn-sm btn-outline-danger" onclick="deleteTopic(${topic.id}); return false;">
                <i class="bi bi-trash"></i>
              </a>
            </div>
            <!-- Editable selects - always visible in edit mode -->
            <div id="topic-edit-selects-${topic.id}" style="display: none;">
              <div class="mb-2 mt-2">
                <select class="form-select form-select-sm w-auto d-inline-block me-2" id="topic-seriousness-${topic.id}">
                  <option value="SERIOUS" ${topic.subscriptions?.seriousness == 'SERIOUS' ? 'selected' : ''}>Serious</option>
                  <option value="VERY_SERIOUS" ${topic.subscriptions?.seriousness == 'VERY_SERIOUS' ? 'selected' : ''}>Very Serious</option>
                  <option value="CASUAL" ${topic.subscriptions?.seriousness == 'CASUAL' ? 'selected' : ''}>Casual</option>
                </select>
                <select class="form-select form-select-sm w-auto d-inline-block me-2" id="topic-visibility-${topic.id}">
                  <option value="PRIVATE" ${topic.visibility == 'PRIVATE' ? 'selected' : ''}>Private</option>
                  <option value="PUBLIC" ${topic.visibility == 'PUBLIC' ? 'selected' : ''}>Public</option>
                </select>
              </div>
            </div>
          </div>
        </div>
        <g:if test="${idx < topics.size() - 1}">
          <hr style="margin: 6px 0 0 0; border-top: 1px solid #eee;">
        </g:if>
      </div>
    </g:each>
    <!-- Pagination -->
    <%
      int maxPerPage = max ?: 10
      int totalCount = topicCount ?: topics.size()
      int offsetVal = offset ?: 0
      int totalPages = (totalCount / maxPerPage) + ((totalCount % maxPerPage) > 0 ? 1 : 0)
      int currentPage = (offsetVal / maxPerPage) + 1
    %>
    <div class="m-1 d-flex justify-content-end">
      <nav aria-label="Page navigation">
        <ul class="pagination pagination-sm mb-0">
          <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
            <button class="page-link"
                    onclick="loadEditTopics(${Math.max(0, offsetVal - maxPerPage)})">Previous</button>
          </li>
          <g:each in="${(1..totalPages)}" var="pageNum">
            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
              <button class="page-link"
                      onclick="loadEditTopics(${(pageNum - 1) * maxPerPage})">${pageNum}</button>
            </li>
          </g:each>
          <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
            <button class="page-link"
                    onclick="loadEditTopics(${offsetVal + maxPerPage})">Next</button>
          </li>
        </ul>
      </nav>
    </div>
  </div>
</g:if>
<g:else>
  <div class="alert alert-warning">No topics found</div>
</g:else>

<script>
let originalValues = {};

function debugToggleEdit(topicId) {
    // Save original values before editing
    originalValues[topicId] = {
        name: document.getElementById('topic-name-input-' + topicId).value,
        seriousness: document.getElementById('topic-seriousness-' + topicId).value,
        visibility: document.getElementById('topic-visibility-' + topicId).value
    };
    
    // Hide all edit fields for all topics
    document.querySelectorAll('[id^="topic-name-edit-"]').forEach(el => el.style.display = 'none');
    document.querySelectorAll('[id^="topic-edit-selects-"]').forEach(el => el.style.display = 'none');
    document.querySelectorAll('[id^="topic-name-display-"]').forEach(el => el.style.display = 'block');

    // Show edit input for this topic
    document.getElementById('topic-name-display-' + topicId).style.display = 'none';
    document.getElementById('topic-name-edit-' + topicId).style.display = 'inline';
    document.getElementById('topic-edit-selects-' + topicId).style.display = 'block';

    // Focus the input
    var input = document.getElementById('topic-name-input-' + topicId);
    if (input) input.focus();
}

function cancelEdit(topicId) {
    if (originalValues[topicId]) {
        document.getElementById('topic-name-input-' + topicId).value = originalValues[topicId].name;
        document.getElementById('topic-seriousness-' + topicId).value = originalValues[topicId].seriousness;
        document.getElementById('topic-visibility-' + topicId).value = originalValues[topicId].visibility;
    }
    
    document.getElementById('topic-name-edit-' + topicId).style.display = 'none';
    document.getElementById('topic-edit-selects-' + topicId).style.display = 'none';
    document.getElementById('topic-name-display-' + topicId).style.display = 'block';
}

// Enhanced save functionality with better error handling and UI updates
function saveTopicAjax(topicId) {
    const nameInput = document.getElementById('topic-name-input-' + topicId);
    const seriousnessSelect = document.getElementById('topic-seriousness-' + topicId);
    const visibilitySelect = document.getElementById('topic-visibility-' + topicId);

    if (!nameInput || !seriousnessSelect || !visibilitySelect) {
        alert('Input elements not found for topic: ' + topicId);
        return;
    }

    const updatedData = {
        id: topicId,
        name: nameInput.value.trim(),
        seriousness: seriousnessSelect.value,
        visibility: visibilitySelect.value
    };

    if (!updatedData.name) {
        alert('Topic name cannot be empty');
        return;
    }

    // Show saving status
    const saveBtn = document.querySelector('#topic-name-edit-' + topicId + ' .btn-outline-secondary');
    if (saveBtn) {
        saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...';
        saveBtn.disabled = true;
    }

    fetch('/topic/edit', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify(updatedData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update the UI in-place
            const topicNameLink = document.getElementById('topic-name-display-' + topicId).querySelector('a');
            if (topicNameLink) {
                topicNameLink.textContent = updatedData.name;
            }
            
            // Update the badge for visibility
            const visibilityBadge = document.querySelector('#topic-name-display-' + topicId).parentElement.parentElement.querySelector('.badge');
            if (visibilityBadge) {
                visibilityBadge.textContent = updatedData.visibility;
            }
            
            // Exit edit mode
            cancelEdit(topicId);
            
            // Show success message
            if (typeof showToast === 'function') {
                showToast('Topic updated successfully!', 'success');
            } else {
                // Create a small notification
                const notification = document.createElement('div');
                notification.className = 'alert alert-success position-fixed bottom-0 end-0 m-3 fade show';
                notification.innerHTML = 'Topic updated successfully! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
                document.body.appendChild(notification);
                
                // Hide notification after 3 seconds
                setTimeout(() => {
                    notification.classList.remove('show');
                    setTimeout(() => notification.remove(), 150);
                }, 3000);
            }
        } else {
            alert('Failed to update topic: ' + (data.error || 'Unknown error'));
            if (saveBtn) {
                saveBtn.innerHTML = 'Save';
                saveBtn.disabled = false;
            }
        }
    })
    .catch(error => {
        console.error('Error updating topic:', error);
        alert('Error updating topic: ' + error.message);
        if (saveBtn) {
            saveBtn.innerHTML = 'Save';
            saveBtn.disabled = false;
        }
    });
}

function deleteTopic(topicId) {
    if (!confirm('Are you sure you want to delete this topic? This will remove all associated resources and subscriptions.')) {
        return;
    }
    
    // Show deleting state on the button
    const deleteBtn = document.querySelector('a[onclick*="deleteTopic(' + topicId + ')"]');
    if (deleteBtn) {
        deleteBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Deleting...';
        deleteBtn.classList.add('disabled');
    }
    
    fetch('/topic/delete', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify({ id: topicId })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Show success message
            if (typeof showToast === 'function') {
                showToast('Topic deleted successfully!', 'success');
            }
            
            // Find and remove the topic element
            const topicElement = document.querySelector('.post-item').closest('[id^="topic-' + topicId + '"]') || 
                               document.querySelector(`[onclick*="deleteTopic(${topicId})"]`).closest('.post-item');
            if (topicElement) {
                topicElement.style.opacity = '0';
                setTimeout(() => {
                    topicElement.remove();
                    // If no topics left, reload to show "No topics found" message
                    if (document.querySelectorAll('.post-item').length === 0) {
                        loadEditTopics(0);
                    }
                }, 500);
            } else {
                // Fallback to reload
                loadEditTopics(0);
            }
        } else {
            alert('Failed to delete topic: ' + (data.error || 'Unknown error'));
            if (deleteBtn) {
                deleteBtn.innerHTML = '<i class="bi bi-trash"></i>';
                deleteBtn.classList.remove('disabled');
            }
        }
    })
    .catch(error => {
        console.error('Error deleting topic:', error);
        alert('Error deleting topic: ' + error.message);
        if (deleteBtn) {
            deleteBtn.innerHTML = '<i class="bi bi-trash"></i>';
            deleteBtn.classList.remove('disabled');
        }
    });
}

// Helper function for toast notifications
function showToast(message, type = 'info') {
    // Check if toast container exists, if not create it
    let toastContainer = document.getElementById('toast-container');
    
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.className = 'position-fixed bottom-0 end-0 p-3';
        document.body.appendChild(toastContainer);
    }
    
    // Create toast element
    const toastId = 'toast-' + Date.now();
    const toastHTML = `
        <div id="${toastId}" class="toast align-items-center text-white bg-${type}" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    `;
    
    // Add toast to container
    toastContainer.insertAdjacentHTML('beforeend', toastHTML);
    
    // Initialize and show toast
    const toastElement = document.getElementById(toastId);
    const toast = new bootstrap.Toast(toastElement, { delay: 3000 });
    toast.show();
    
    // Remove toast after it's hidden
    toastElement.addEventListener('hidden.bs.toast', function() {
        toastElement.remove();
    });
}

function loadEditTopics(offset) {
    const search = document.getElementById("topicSearch") ? document.getElementById("topicSearch").value.trim() : "";
    let url = '/user/editTopic?max=10&offset=' + (offset || 0);
    if (search) url += '&search=' + encodeURIComponent(search);
    fetch(url)
        .then(res => res.text())
        .then(html => {
            document.getElementById('topic-section').innerHTML = html;
        });
}

// Enable inline editing by adding double-click event listeners to topic names
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('[id^="topic-name-display-"]').forEach(element => {
        const topicId = element.id.replace('topic-name-display-', '');
        
        element.addEventListener('dblclick', function() {
            debugToggleEdit(topicId);
        });
    });
});

// Make functions globally accessible
window.debugToggleEdit = debugToggleEdit;
window.saveTopicAjax = saveTopicAjax;
window.cancelEdit = cancelEdit;
window.deleteTopic = deleteTopic;
window.loadEditTopics = loadEditTopics;
window.showToast = showToast;
</script>

<style>
.post-item {
    transition: opacity 0.5s ease-out;
}
</style>