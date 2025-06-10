// Shared AJAX subscribe/unsubscribe logic for LinkSharing
function reloadSubscriptions() {
    fetch('/user/refreshSubscriptions')
        .then(res => {
            if (!res || !res.ok) {
                throw new Error(`HTTP error! Status: ${res ? res.status : 'No response'}`);
            }
            return res.text();
        })
        .then(html => {
            const section = document.getElementById('subscriptions-section');
            if (section) section.innerHTML = html;
        })
        .catch(error => console.error('Error refreshing subscriptions:', error));
}

function reloadTrendingTopics() {
    fetch('/user/refreshTopics')
        .then(res => {
            if (!res || !res.ok) {
                throw new Error(`HTTP error! Status: ${res ? res.status : 'No response'}`);
            }
            return res.text();
        })
        .then(html => {
            const section = document.getElementById('trending-topics-section');
            if (section) section.innerHTML = html;
        })
        .catch(error => console.error('Error refreshing trending topics:', error));
}

function ajaxSubscribe(topicId, btn) {
    if (!topicId) {
        console.error('No topic ID provided for subscription');
        return;
    }
    
    fetch('/user/ajaxSubscribe?topicId=' + topicId, {
        method: 'POST',
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
        }
    })
    .then(res => {
        if (!res || !res.ok) {
            throw new Error(`HTTP error! Status: ${res ? res.status : 'No response'}`);
        }
        return res.json();
    })
    .then(data => {
        if (data && data.success) {
            if (btn) {
                btn.classList.remove('btn-outline-primary');
                btn.classList.add('btn-outline-danger');
                btn.textContent = 'Unsubscribe';
                // Update onclick with an anonymous function to prevent reference issues
                btn.onclick = function() { ajaxUnsubscribe(topicId, this); };
            }
            // Refresh both sections to update counts
            reloadSubscriptions();
            reloadTrendingTopics();
        } else {
            console.warn(data ? data.message : 'Failed to subscribe - unknown error');
            alert(data && data.message ? data.message : 'Failed to subscribe');
        }
    })
    .catch(error => {
        console.error('Error subscribing:', error);
        alert('Error occurred while subscribing. Please try again.');
    });
}

function ajaxUnsubscribe(topicId, btn) {
    if (!topicId) {
        console.error('No topic ID provided for unsubscription');
        return;
    }
    
    fetch('/user/ajaxUnsubscribe?topicId=' + topicId, {
        method: 'POST',
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
        }
    })
    .then(res => {
        if (!res || !res.ok) {
            throw new Error(`HTTP error! Status: ${res ? res.status : 'No response'}`);
        }
        return res.json();
    })
    .then(data => {
        if (data && data.success) {
            if (btn) {
                btn.classList.remove('btn-outline-danger');
                btn.classList.add('btn-outline-primary');
                btn.textContent = 'Subscribe';
                // Update onclick with an anonymous function to prevent reference issues
                btn.onclick = function() { ajaxSubscribe(topicId, this); };
            }
            // Refresh both sections to update counts
            reloadSubscriptions();
            reloadTrendingTopics();
        } else {
            console.warn(data ? data.message : 'Failed to unsubscribe - unknown error');
            alert(data && data.message ? data.message : 'Failed to unsubscribe');
        }
    })
    .catch(error => {
        console.error('Error unsubscribing:', error);
        alert('Error occurred while unsubscribing. Please try again.');
    });
}
