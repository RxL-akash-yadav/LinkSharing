package LinkSharing

import com.example.Subscription
import com.example.Seriousness
import grails.converters.JSON
import grails.gorm.transactions.Transactional

class SubscriptionController {

    @Transactional
    def updateSeriousness() {
        log.info("updateSeriousness called with params: ${params}")
        String subscriptionId = params.id
        String seriousness = params.seriousness
        
        log.info("Processing subscription ID: ${subscriptionId}, seriousness: ${seriousness}")
        
        if (!subscriptionId) {
            log.error("Missing subscription ID")
            response.status = 400
            render([success: false, error: "Missing subscription ID"] as JSON)
            return
        }
        
        if (!seriousness) {
            log.error("Missing seriousness value")
            response.status = 400
            render([success: false, error: "Missing seriousness value"] as JSON)
            return
        }
        
        try {
            def subscription = Subscription.get(subscriptionId)
            
            if (!subscription) {
                log.warn("Subscription not found for ID: ${subscriptionId}")
                render([success: false, error: "Subscription not found"] as JSON)
                return
            }
            
            if (subscription.user.id != session.user?.id) {
                log.warn("Unauthorized access: ${session.user?.id} tried to update subscription of user ${subscription.user.id}")
                render([success: false, error: "Not authorized"] as JSON)
                return
            }
            
            // Make sure the seriousness value is valid
            try {
                subscription.seriousness = Seriousness.valueOf(seriousness)
            } catch (IllegalArgumentException e) {
                log.error("Invalid seriousness value: ${seriousness}", e)
                render([success: false, error: "Invalid seriousness value: ${seriousness}"] as JSON)
                return
            }
            
            // Save the subscription
            if (!subscription.save(flush: true)) {
                log.error("Failed to save subscription: ${subscription.errors}")
                render([success: false, error: "Failed to save: ${subscription.errors}"] as JSON)
                return
            }
            
            log.info("Successfully updated seriousness to ${seriousness} for subscription ${subscriptionId}")
            render([success: true] as JSON)
            
        } catch (Exception e) {
            log.error("Error updating subscription seriousness: ${e.message}", e)
            render([success: false, error: e.message] as JSON)
        }
    }
}
