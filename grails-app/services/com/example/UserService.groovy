package com.example


import grails.gorm.transactions.Transactional
import groovy.transform.CompileStatic
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder



@Transactional
class UserService {

    PasswordEncoder passwordEncoder = new BCryptPasswordEncoder()

    /**
     * Parameters for user registration.
     */
    def registerUser(MultipartHttpServletRequest request) {

        if (AppUser.findByUsername(userParams.username)) {
            return [
                    success: false,
                    message: 'Username already exists',
                    errors: ['Username is already taken']
            ]
        }

        if (AppUser.findByEmail(userParams.email)) {
            return [
                    success: false,
                    message: 'Email already exists',
                    errors: ['Email address is already registered']
            ]
        }

        AppUser user = new AppUser()
        user.username = userParams.username.trim()
        user.email = userParams.email.trim().toLowerCase()
        user.firstName = userParams.firstName.trim()
        user.lastName = userParams.lastName.trim()
        user.password = encryptPassword((String)userParams.password)
        user.admin = false
        user.active=true
        def photoFile = request.getFile("photo")
        if (photoFile && !photoFile.empty) {
            user.photo = photoFile.bytes
        }

        if (user.save(flush: true)) {
            log.info("User registered successfully: ${user.username}")
            return [
                    success: true,
                    message: 'User registered successfully',
                    user: user
            ]
        } else {
            return [
                    success: false,
                    message: 'Failed to save user',
                    errors: "User not registered"
            ]
        }
    }

    /**
     * Validates the raw password against the encoded password.
     *
     * @param rawPassword The raw password to validate
     * @param encodedPassword The encoded password to compare against
     * @return true if the passwords match, false otherwise
     */
    def validatePassword(String rawPassword, String encodedPassword) {
        return passwordEncoder.matches(rawPassword, encodedPassword)
    }

    /**
     * Encrypts the given password using BCrypt.
     *
     * @param password The raw password to encrypt
     * @return The encrypted password
     */
    def encryptPassword(String password) {
        return passwordEncoder.encode(password)
    }

    /**
     * Updates the user profile with the provided parameters.
     *
     * @param user The AppUser object to update
     * @param params The parameters containing updated user information
     * @param request The MultipartHttpServletRequest for file uploads
     * @return true if the update was successful, false otherwise
     */
    def updateProfile(AppUser user, Map params, MultipartHttpServletRequest request) {
        if (!user) return false

        user.with {
            if (params.firstName) firstName = params.firstName
            if (params.lastName) lastName = params.lastName
            if (params.username) username = params.username

            def photoFile = request.getFile("photo")
            if (photoFile && !photoFile.empty) {
                photo = photoFile.bytes
            }
        }

        return user.save(flush: true)
    }

    /**
     * Changes the password for the given user.
     *
     * @param user The AppUser whose password is to be changed
     * @param params The parameters containing the new password and confirmation
     * @return true if the password was changed successfully, false otherwise
     */
    def changePassword(AppUser user, Map params) {
        if (!user) return false

        String password = params.password
        String confirmPassword = params.confirmPassword

        if (!password || !confirmPassword) return false
        if (password != confirmPassword) return false

        user.password = passwordEncoder.encode(password)

        return user.save(flush: true)
    }
}