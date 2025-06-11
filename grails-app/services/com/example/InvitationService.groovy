package com.example

import grails.gorm.transactions.Transactional
import groovy.util.logging.Slf4j
import org.springframework.beans.factory.annotation.Value

@Slf4j
@Transactional
class InvitationService {

    def mailService

    @Value('${app.baseUrl:http://localhost:8080}')
    String baseUrl

    @Value('${app.name:Link Sharing}')
    String appName

    /**
     * Sends an invitation email to a user for a specific topic.
     *
     * @param recipientEmail The email address of the recipient.
     * @param topic The topic to which the user is being invited.
     * @return A map containing the success status and message.
     */
    def sendTopicInvitation(String recipientEmail, Topic topic) {
        try {
            String topicLink = generateTopicLink(topic)
            log.debug("Generated topic link: ${topicLink}")

            String emailBody = """
                Hello,
                You have been invited to view the topic: ${topic.name}
                Click ${topicLink} to access the topic.
                Thanks,${appName} Team
            """

            if (!mailService) {
                log.error("MailService is not available. Check if Grails Mail plugin is properly configured.")
                return [success: false, message: "Mail service not configured."]
            }

            mailService.sendMail {
                to recipientEmail
                subject "You're invited to explore: ${topic.name}"
                body emailBody
            }

            log.info("Topic invitation sent successfully to: ${recipientEmail} for topic: ${topic.name}")

            return [
                    success: true,
                    message: "Invitation sent successfully",
                    topicLink: topicLink
            ]

        } catch (Exception e) {
            log.error("Failed to send topic invitation to: ${recipientEmail}", e)
            return [
                    success: false,
                    message: "Failed to send invitation: ${e.message}"
            ]
        }
    }

    /**
     * Generates a link to the topic.
     *
     * @param topic The topic for which the link is generated.
     * @return The URL to access the topic.
     */
    private String generateTopicLink(def topic) {
        return "${baseUrl}/resource/topic/${topic.id}"
    }
}