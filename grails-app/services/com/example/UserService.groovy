package com.example


import grails.gorm.transactions.Transactional
import groovy.transform.CompileStatic
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder



@Transactional
class UserService {

    PasswordEncoder passwordEncoder = new BCryptPasswordEncoder()


    def registerUser(Map userParams) {

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
        user.password = encryptPassword(userParams.password)
        user.admin = false
        user.active=true

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


    def findUserById(Long id){
        return AppUser.get(id)
    }

    def validatePassword(String rawPassword, String encodedPassword) {
        return passwordEncoder.matches(rawPassword, encodedPassword)
    }

    def encryptPassword(String password) {
        return passwordEncoder.encode(password)
    }

    def findUserByUsername(String username) {
        return AppUser.findByUsername(username)
    }

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