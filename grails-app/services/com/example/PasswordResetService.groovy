package com.example

import grails.gorm.transactions.Transactional
import grails.web.mapping.LinkGenerator

@Transactional
class PasswordResetService {

    def mailService
    def grailsApplication
    AuthenticationService authenticationService
    UserService userService
    LinkGenerator grailsLinkGenerator

    def sendPasswordResetEmail(String email) {
        try {
            AppUser user = AppUser.findByEmail(email)

            if (!user) {
                return [
                    success: false,
                    message: "No account found with that email address"
                ]
            }

            def tokenResult = authenticationService.generatePasswordResetToken(user)

            if (!tokenResult.success) {
                return tokenResult
            }

            String token = tokenResult.token
            String resetLink = generateResetLink(token)

            String appName = grailsApplication.config.getProperty('app.name') ?: 'LinkSharing'
            String emailBody = """
                Hello ${user.firstName},
                
                You recently requested to reset your password for your ${appName} account.
                
                Click the link below to reset it:
                ${resetLink}
                
                This password reset link is only valid for the next 24 hours.
                
                If you did not request a password reset, please ignore this email or contact support if you have concerns.
                
                Thanks,
                ${appName} Team
            """

            mailService.sendMail {
                to email
                subject "Reset Your Password - ${appName}"
                text emailBody
            }

            return [
                success: true,
                message: "Password reset instructions sent to your email"
            ]

        } catch (Exception e) {
            log.error("Failed to send password reset email to: ${email}", e)
            return [
                success: false,
                message: "Failed to send password reset email: ${e.message}"
            ]
        }
    }

    private String generateResetLink(String token) {
        return grailsLinkGenerator.link(controller: 'home', action: 'resetPassword', params: [token: token], absolute: true)
    }
}
