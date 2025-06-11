package LinkSharing

import com.example.AppResource
import com.example.ResourceRating
import com.example.AuthenticationService
import com.example.ResourceService
import com.example.Visibility
import com.example.UserService
import org.springframework.security.access.annotation.Secured
import java.time.LocalDateTime
import java.time.ZoneId


@Secured(['permitAll'])
class HomeController {

    AuthenticationService authenticationService
    UserService userService
    ResourceService resourceService

    def index() {
        if (session.user) {
            redirect(controller: 'user', action: 'dashboard')
        } else {
            render(view: 'homepage')
        }
    }


    def recentSharesAjax() {
        List<AppResource> latestPost = resourceService.getLatestPublicResources()
        render(template: "/home/recentShares", model: [latestPost: latestPost])
    }

    def topPostAjax() {
        String filter = params.filter ?: 'week'

        LocalDateTime now = LocalDateTime.now()
        LocalDateTime startDate

        switch (filter) {
            case 'week':
                startDate = now.minusDays(7)
                break
            case 'month':
                startDate = now.minusMonths(1)
                break
            case 'year':
                startDate = now.minusYears(1)
                break
            default:
                startDate = now.minusDays(1)

        }

        Date fromDate = Date.from(startDate.atZone(ZoneId.systemDefault()).toInstant())

        List<AppResource> resources = AppResource.createCriteria().list {
            ge('dateCreated', fromDate)
            topic {
                eq('visibility', com.example.Visibility.PUBLIC)
            }
        }

        def ratingMap = [:]
        resources.each { AppResource resource ->
            def avgScore = ResourceRating.executeQuery(
                    'select avg(r.score) from ResourceRating r where r.resource.id = :resId',
                    [resId: resource.id]
            )?.get(0) ?: 0.0
            ratingMap[resource.id] = avgScore
        }

        List<AppResource> sortedTopPosts = resources.sort { a, b ->
            (ratingMap[b.id] ?: 0.0) <=> (ratingMap[a.id] ?: 0.0)
        }

        // Take only the top 5 after sorting
        sortedTopPosts = sortedTopPosts.take(5)

        render(template: "/home/topPostAjax", model: [topPost: sortedTopPosts])
    }

    List<AppResource> top5PublicRatedByFilter(String filter) {
        LocalDateTime now = LocalDateTime.now()
        LocalDateTime temp

        switch (filter) {
            case 'week':
                temp = now.minusDays(7)
                break
            case 'month':
                temp = now.minusMonths(1)
                break
            case 'year':
                temp = now.minusYears(1)
                break
            default:
                temp = now.minusDays(1)
        }

        Date fromDate = Date.from(temp.atZone(ZoneId.systemDefault()).toInstant())

        return AppResource.createCriteria().list(max: 5) {
            ge('dateCreated', fromDate)
            topic {
                eq('visibility', Visibility.PUBLIC)
            }
        }
    }


    def register() {
        try {

            def result = userService.registerUser(params)
             println result

            if (result.success) {
                authenticationService.authenticateUser(result.user.username)
                session.user = result.user
                redirect(controller :'user' , action : 'dashboard')
            } else {
                redirect(controller: 'home' ,action: 'index')
            }
        } catch (Exception e) {
            log.error("Registration error: ${e.message}", e)
            render(contentType: 'application/json') {
                [
                        success: false,
                        message: 'Registration failed due to server error',
                        errors: [e.message]
                ]
            }
        }
    }

    def login() {
        String username = params.username
        String password = params.password

        if (!username || !password) {
            flash.error = "Username and password are required"
            redirect(controller: 'home', action: 'index')
            return
        }

        def result = authenticationService.authenticateUser(username, password)

        if (result.success) {
            session.user = result.user
            flash.message = result.message
            redirect(controller: 'user', action: 'dashboard')
        } else {
            flash.error = result.message
            redirect(controller: 'home', action: 'index')
        }
    }

    @Secured(['ROLE_USER', 'ROLE_ADMIN'])
    def logout() {
        try {
            authenticationService.logoutUser()
            redirect(controller: "home" , action: "index")
        } catch (Exception e) {
            log.error("Logout error: ${e.message}", e)
            render(contentType: 'application/json') {
                [
                        success: false,
                        message: 'Logout failed',
                        errors: [e.message]
                ]
            }
            redirect(controller: "user", action: "dashboard")
        }
    }

    def forgotPassword() {
        if (request.method == 'POST') {
            String email = params.email

            if (!email) {
                flash.error = "Email address is required"
                render(view: 'forgotPassword')
                return
            }

            def passwordResetService = grailsApplication.mainContext.getBean('passwordResetService')
            def result = passwordResetService.sendPasswordResetEmail(email)

            if (result.success) {
                flash.message = result.message
                redirect(controller: 'home', action: 'index')
            } else {
                flash.error = result.message
                render(view: 'forgotPassword')
            }
        } else {
            render(view: 'forgotPassword')
        }
    }

    def resetPassword() {
        String token = params.token

        if (!token) {
            flash.error = "Invalid password reset link"
            redirect(controller: 'home', action: 'index')
            return
        }

        if (request.method == 'POST') {
            String newPassword = params.newPassword
            String confirmPassword = params.confirmPassword

            if (!newPassword || !confirmPassword) {
                flash.error = "Both password fields are required"
                render(view: 'resetPassword', model: [token: token])
                return
            }

            if (newPassword != confirmPassword) {
                flash.error = "Passwords don't match"
                render(view: 'resetPassword', model: [token: token])
                return
            }

            def result = authenticationService.resetPassword(token, newPassword)

            if (result.success) {
                flash.message = result.message
                redirect(controller: 'home', action: 'index')
            } else {
                flash.error = result.message
                redirect(controller: 'home', action: 'index')
            }
        } else {
            def validationResult = authenticationService.validateResetToken(token)

            if (!validationResult.success) {
                flash.error = validationResult.message
                redirect(controller: 'home', action: 'index')
                return
            }
            render(view: 'resetPassword', model: [token: token])
        }
    }
}