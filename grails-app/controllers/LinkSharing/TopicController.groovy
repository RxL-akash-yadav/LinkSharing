package LinkSharing

import com.example.AppUser
import com.example.Subscription
import com.example.InvitationService
import com.example.Topic
import com.example.TopicService
import grails.converters.JSON
import org.springframework.security.access.annotation.Secured
import grails.gorm.transactions.Transactional

@Transactional
@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class TopicController {

    TopicService topicService
    InvitationService invitationService



    def create(){
        if (!request.xhr) {
            render([success: false, error: 'Only AJAX requests are supported'] as JSON)
            return
        }
    
        String name = params.name
        String visibility = params.visibility
        AppUser currentUser = session.user

        if (Topic.findByNameAndCreatedBy(name, currentUser)) {
            render([success: false, error: "You already have a topic with this name."] as JSON)
            return
        }

        try {
            def topic = topicService.createTopic(name, visibility, currentUser)
            def subscription = new Subscription(
                user: currentUser,
                topic: topic,
                seriousness: "VERY_SERIOUS"
            )
            subscription.save(flush: true)
            
            render([
                success: true,
                message: "Topic '${name}' created successfully!",
                topic: [id: topic.id, name: topic.name, visibility: topic.visibility]
            ] as JSON)
        } catch (IllegalArgumentException iae) {
            render([success: false, error: iae.message] as JSON)
        } catch (Exception e) {
            log.error("Error creating topic", e)
            render([success: false, error: "Something went wrong while creating topic!"] as JSON)
        }
    }

    def send() {
        if (!request.xhr) {
            render([success: false, error: 'Only AJAX requests are supported'] as JSON)
            return
        }
        
        try {
            def email = params.email?.trim()
            def topicId = params.topicId as Long

            if (!email || !topicId) {
                render([success: false, error: "Email and topic are required"] as JSON)
                return
            }


            if (!isValidEmail(email)) {
                render([success: false, error: "Please enter a valid email address"] as JSON)
                return
            }

            Topic topic = Topic.get(topicId)
            if (!topic) {
                render([success: false, error: "Selected topic not found"] as JSON)
                return
            }

            def result = invitationService.sendTopicInvitation(email, topic)

            if (result.success) {
                log.info("Topic invitation sent - Email: ${email}, Topic: ${topic.name}, Sent by: ${session.user?.username ?: 'Unknown'}")
                render([success: true, message: "Invitation sent successfully to ${email}"] as JSON)
            } else {
                log.error("Failed to send topic invitation - Email: ${email}, Topic: ${topic.name}, Error: ${result.message}")
                render([success: false, error: result.message ?: "Failed to send invitation. Please try again."] as JSON)
            }
        } catch (Exception e) {
            log.error("Error in topic send action: ${e.message}", e)
            render([success: false, error: "An error occurred while sending the invitation"] as JSON)
        }
    }

    private boolean isValidEmail(String email) {
        def pattern = /^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\.[A-Za-z]{2,})$/
        return email ==~ pattern
    }

    def updateVisibility() {
        def topicId = params.id
        def visibility = params.visibility
        
        try {
            def topic = com.example.Topic.get(topicId)
            
            if (!topic) {
                render([success: false, error: "Topic not found"] as JSON)
                return
            }
            
            if (topic.createdBy.id != session.user?.id && !session.user?.admin) {
                render([success: false, error: "Not authorized"] as JSON)
                return
            }
            
            topic.visibility = com.example.Visibility.valueOf(visibility)
            topic.save(flush: true)
            
            render([success: true] as JSON)
        } catch (Exception e) {
            log.error("Error updating topic visibility", e)
            render([success: false, error: e.message] as JSON)
        }
    }

    def edit() {
        if (!request.xhr) {
            response.status = 400
            render([success: false, error: 'Invalid request'] as JSON)
            return
        }

        try {
            def json = request.JSON
            Long topicId = json.id as Long
            String name = json.name?.trim()
            if(Topic.findByName(name)) {
                response.status = 400
                render([success: false, error: 'Topic with this name already exists'] as JSON)
                return
            }
            String seriousness = json.seriousness
            String visibility = json.visibility

            Topic topic = Topic.get(topicId)
            if (!topic) {
                response.status = 404
                render([success: false, error: 'Topic not found'] as JSON)
                return
            }
            if (topic.createdBy.id != session.user?.id) {
                response.status = 403
                render([success: false, error: 'Not authorized'] as JSON)
                return
            }
            topic.name = name
            topic.visibility = visibility
            topic.save(flush: true)

            def sub = topic.subscriptions?.find { it.user?.id == session.user?.id }
            if (sub && seriousness) {
                sub.seriousness = seriousness
                sub.save(flush: true)
            }

            render([success: true] as JSON)
        } catch (Exception e) {
            log.error("Error editing topic", e)
            response.status = 500
            render([success: false, error: 'Internal Server Error'] as JSON)
        }
    }

    def delete() {
        if (!request.xhr) {
            response.status = 400
            render([success: false, error: 'Invalid request'] as JSON)
            return
        }
        try {
            def json = request.JSON
            Long topicId = json.id as Long

            Topic topic = Topic.get(topicId)
            if (!topic) {
                response.status = 404
                render([success: false, error: 'Topic not found'] as JSON)
                return
            }
            if (topic.createdBy.id != session.user?.id) {
                response.status = 403
                render([success: false, error: 'Not authorized'] as JSON)
                return
            }

            topic.delete(flush: true)

            render([success: true] as JSON)
        } catch (Exception e) {
            log.error("Error deleting topic", e)
            response.status = 500
            render([success: false, error: 'Internal Server Error: ' + e.message] as JSON)
        }
    }
}