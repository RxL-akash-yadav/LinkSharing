package com.example

import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.SpringSecurityService
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.Authentication
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.web.context.request.RequestContextHolder
import org.springframework.web.context.request.ServletRequestAttributes


@Transactional
class AuthenticationService {

    SpringSecurityService springSecurityService
    UserService userService
    PasswordEncoder passwordEncoder = new BCryptPasswordEncoder()

    /**
     * Authenticates a user with the given username and password.
     * If password is null, performs auto-login using the username.
     *
     * @param username The username of the user
     * @param password The password of the user (optional)
     * @return A map containing success status, message, and user information
     */
    def authenticateUser(String username, String password = null) {
        if (password == null) {
            return performAutoLogin(username)
        }

        AppUser user = AppUser.findByUsername(username)

        if (!user) {
            return [
                    success: false,
                    message: 'Invalid username or password',
                    errors: ['Invalid credentials']
            ]
        }

        if (!user.active) {
            return [
                    success: false,
                    message: 'Account is disabled',
                    errors: ['Your account has been disabled. Please contact support.']
            ]
        }


        if (!userService.validatePassword(password, user.password)) {
            return [
                    success: false,
                    message: 'Invalid username or password',
                    errors: ['Invalid credentials']
            ]
        }

        performLogin(user)

        return [
                success: true,
                message: 'Login successful',
                user: user
        ]
    }

    /**
     * Performs auto-login for the user with the given username.
     * This method is used when the user is already authenticated and needs to be logged in again.
     *
     * @param username The username of the user to auto-login
     * @return A map containing success status, message, and user information
     */
    def performAutoLogin(String username) {
        try {
            AppUser user = userService.findUserByUsername(username)

            if (!user) {
                return [
                        success: false,
                        message: 'User not found',
                        errors: ['User does not exist']
                ]
            }

            performLogin(user)

            return [
                    success: true,
                    message: 'Auto-login successful',
                    user: user
            ]

        } catch (Exception e) {
            log.error("Auto-login error for username ${username}: ${e.message}", e)
            return [
                    success: false,
                    message: 'Auto-login failed',
                    errors: [e.message]
            ]
        }
    }

    /**
     * Logs out the current user and invalidates the session.
     * Clears the security context to remove authentication information.
     *
     * @return A map containing success status and message
     */
    def logoutUser() {
        try {
            def requestAttributes = RequestContextHolder.getRequestAttributes()
            if (requestAttributes instanceof ServletRequestAttributes) {
                def request = ((ServletRequestAttributes) requestAttributes).getRequest()
                def session = request.session
                def currentUser = session.user

                session.invalidate()
                SecurityContextHolder.clearContext()

                if (currentUser) {
                    log.info("User logged out successfully: ${currentUser.username}")
                }

                return [
                        success: true,
                        message: 'Logout successful'
                ]
            } else {
                log.warn("Could not obtain HttpServletRequest")
                return [
                        success: false,
                        message: 'No HTTP request found'
                ]
            }

        } catch (Exception e) {
            log.error("Logout error: ${e.message}", e)
            return [
                    success: false,
                    message: 'Logout failed',
                    errors: [e.message]
            ]
        }
    }

    /**
     * Performs the login operation by setting the security context with the user's authentication details.
     * This method is called after successful user authentication.
     *
     * @param user The AppUser object representing the authenticated user
     */
    private def performLogin(AppUser user) {
        def authorities = []

        if (user.admin) {
            authorities << new SimpleGrantedAuthority('ROLE_ADMIN')
            authorities << new SimpleGrantedAuthority('ROLE_USER')
        } else {
            authorities << new SimpleGrantedAuthority('ROLE_USER')
        }

        Authentication authentication = new UsernamePasswordAuthenticationToken(
                user,
                null,
                authorities
        )

        SecurityContextHolder.context.authentication = authentication
        if (RequestContextHolder.requestAttributes instanceof ServletRequestAttributes) {
            def request = ((ServletRequestAttributes) RequestContextHolder.requestAttributes).request
            def session = request.getSession(true)
            session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.context)
        }
    }

    /**
     * Generates a password reset token for the given user.
     * The token is valid for 24 hours.
     *
     * @param user The AppUser for whom the token is generated
     * @return A map containing success status, token, and user information
     */
    def generatePasswordResetToken(AppUser user) {
        if (!user) {
            return [
                success: false,
                message: "User not found",
                errors: ["Invalid user"]
            ]
        }

        String token = UUID.randomUUID().toString()

        Date expiryDate = new Date(System.currentTimeMillis() + (24 * 60 * 60 * 1000))

        user.resetToken = token
        user.resetTokenExpiry = expiryDate

        if (user.save(flush: true)) {
            return [
                success: true,
                token: token,
                user: user
            ]
        } else {
            return [
                success: false,
                message: "Could not save reset token",
                errors: user.errors.allErrors*.defaultMessage
            ]
        }
    }

    /**
     * Validates the password reset token.
     * If valid, returns the user associated with the token.
     *
     * @param token The password reset token
     * @return A map containing success status, user information, or error messages
     */
    def validateResetToken(String token) {
        if (!token) {
            return [
                success: false,
                message: "Invalid token",
                errors: ["Token is required"]
            ]
        }

        AppUser user = AppUser.findByResetToken(token)

        if (!user) {
            return [
                success: false,
                message: "Invalid or expired token",
                errors: ["Token not found"]
            ]
        }

        if (!user.resetTokenExpiry || user.resetTokenExpiry < new Date()) {
            user.resetToken = null
            user.resetTokenExpiry = null
            user.save(flush: true)

            return [
                success: false,
                message: "Token has expired",
                errors: ["Please request a new password reset link"]
            ]
        }

        return [
            success: true,
            user: user
        ]
    }

    /**
     * Resets the password for the user associated with the given token.
     * The token must be valid and not expired.
     *
     * @param token The password reset token
     * @param newPassword The new password to set
     * @return A map containing success status, message, or error messages
     */
    def resetPassword(String token, String newPassword) {
        def validationResult = validateResetToken(token)

        if (!validationResult.success) {
            return validationResult
        }

        AppUser user = validationResult.user

        user.password = passwordEncoder.encodePassword(newPassword)

        user.resetToken = null
        user.resetTokenExpiry = null

        if (user.save(flush: true)) {
            return [
                success: true,
                message: "Password has been reset successfully"
            ]
        } else {
            return [
                success: false,
                message: "Could not reset password",
                errors: user.errors.allErrors*.defaultMessage
            ]
        }
    }
}