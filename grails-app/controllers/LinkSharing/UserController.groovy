package LinkSharing

import com.example.AppResource
import com.example.AppUser
import com.example.ResourceService
import com.example.Subscription
import com.example.SubscriptionService
import com.example.Topic
import com.example.TopicService
import com.example.UserService
import grails.converters.JSON
import grails.gorm.transactions.Transactional
import org.springframework.security.access.annotation.Secured
import org.hibernate.FetchMode
import org.springframework.web.multipart.MultipartHttpServletRequest



@Secured(['permitAll'])
@Transactional
class UserController {

    TopicService topicService

    ResourceService resourceService

    SubscriptionService subscriptionService

    UserService userService

    def profile(Long id) {
        if(!session.user){
            flash.message = "Login to see profile"
            redirect(controller: 'home', action: 'index')
            return
        }

        if (!id) {
            flash.message = "User ID not specified."
            redirect(controller: 'home', action: 'index')
            return
        }

        def user = AppUser.findById(id)
        if (!user) {
            flash.message = "User not found."
            redirect(controller: 'home', action: 'index')
            return
        }




        int subCount = Subscription.findAllByUser(user).size()
        int topicCount = Topic.findAllByCreatedBy(user).size()



        int postCount = AppResource.countByCreatedBy(user)

        render(view: 'profile', model: [
                user: user,
                subCount: subCount,
                topicCount: topicCount
        ])
    }

    def loadTopicsAjax() {
        def userId = params.long('userId')

        def user = AppUser.get(params.userId)
        if (!user) {
            render status: 404, text: "User not found"
            return
        }

        int max = 5
        int offset = params.int('offset') ?: 0
        String searchTerm = params.search?.trim()

        def topics = Topic.createCriteria().list {
            eq("createdBy", user)
            if (searchTerm) {
                ilike("name", "%${searchTerm}%")
            }
            maxResults(max)
            firstResult(offset)
        }

        int topicCount = Topic.createCriteria().count {
            eq("createdBy", user)
            if (searchTerm) {
                ilike("name", "%${searchTerm}%")
            }
        }

        render(template: '/user/profileTopics', model: [
                topics: topics,
                topicCount: topicCount,
                max: max,
                offset: offset
        ])
    }

    def loadSubscriptionsAjax() {
        def userId = params.long('userId')

        def user = AppUser.get(params.userId)
        if (!user) {
            render status: 403, text: "Unauthorized"
            return
        }

        int max = Math.min(params.int('max') ?: 5, 100)
        int offset = params.int('offset') ?: 0
        String search = params.search?.trim()

        def subscriptionsList = Subscription.createCriteria().list {
            eq("user", user)
            if (search) {
                topic {
                    ilike("name", "%${search}%")
                }
            }
            maxResults(max)
            firstResult(offset)
        }

        int subscriptionCount = Subscription.createCriteria().count {
            eq("user", user)
            if (search) {
                topic {
                    ilike("name", "%${search}%")
                }
            }
        }

        render(template: '/user/subscriptionsList', model: [
                subscriptionsList : subscriptionsList,
                subscriptionCount : subscriptionCount,
                offset            : offset,
                max               : max
        ])
    }

    def loadPostsAjax() {
        def userId = params.long('userId')

        def user = AppUser.get(params.userId)
        if (!user) {
            render status: 404, text: "User not found"
            return
        }

        int max = Math.min(params.int('max') ?: 20, 100)
        int offset = params.int('offset') ?: 0
        String search = params.search?.trim()

        def c = AppResource.createCriteria()
        def posts = c.list(max: max, offset: offset) {
            eq('createdBy', user)
            if (search) {
                or{
                    ilike('description', "%${search}%")
                    topic{
                        ilike('name', "%${search}%")
                    }
                }
            }
            order('dateCreated', 'desc')
        }

        def postCount = AppResource.createCriteria().count {
            eq('createdBy', user)
            or{
                ilike('description', "%${search}%")
                topic{
                    ilike('name', "%${search}%")
                }
            }
        }

        render(template: '/user/postsList', model: [
                posts     : posts,
                postCount : postCount,
                offset    : offset,
                max       : max,
                user      : user
        ])

    }

    def editprofile() {

        AppUser user = session.user
        int topicCount = Topic.findAllByCreatedBy(user).size()
        int subscriptionCount = Subscription.findAllByUser(user).size()
        def topics = Topic.findAllByCreatedBy(user) // Add this line

        render(view: "editprofile", model: [user:user,
                                            topicCount:topicCount,
                                            subscriptionCount:subscriptionCount,
                                            topics: topics // And add this to the model
        ])
    }

    def updateTopic() {
        println "hello"
        try {
            def json = request.JSON
            log.info("Received JSON: ${json}")

            Topic topic = Topic.get(json.id)
            if (!topic) {
                log.error("Topic not found with id: ${json.id}")
                render([success: false, message: "Topic not found"] as JSON)
                return
            }

            if (topic.createdBy.id != session.user.id) {
                log.error("User ${session.user.id} not authorized to edit topic ${topic.id}")
                render([success: false, message: "Not authorized"] as JSON)
                return
            }

            // Update topic properties
            topic.name = json.name
            topic.visibility = json.visibility

            // Update subscription seriousness - find the user's subscription to this topic
            def userSubscription = Subscription.findByTopicAndUser(topic, session.user)
            if (userSubscription) {
                userSubscription.seriousness = json.seriousness
                userSubscription.save(flush: true)
            } else {
                log.warn("No subscription found for user ${session.user.id} and topic ${topic.id}")
            }

            if (topic.save(flush: true)) {
                log.info("Topic ${topic.id} updated successfully")
                render([success: true, message: "Topic updated successfully"] as JSON)
            } else {
                log.error("Failed to save topic: ${topic.errors}")
                render([success: false, message: "Failed to save topic", errors: topic.errors] as JSON)
            }

        } catch (Exception e) {
            log.error("Error updating topic: ${e.message}", e)
            render([success: false, message: "Server error: ${e.message}"] as JSON)
        }
    }

    def editTopic() {
        AppUser user = session.user
        def search = params.search?.trim()

        List<Topic> topics = Topic.createCriteria().list {
            eq("createdBy", user)
            if (search) {
                ilike("name", "%${search}%")
            }
        }

        render template: '/user/editTopic', model: [topics: topics]
    }

    def updateProfile() {
        def user = session.user

        if (!(request instanceof MultipartHttpServletRequest)) {
            flash.error = "Invalid form submission"
            redirect(controller: 'user', action: 'editprofile')
            return
        }

        boolean updated = userService.updateProfile(user, params, request)

        if (updated) {
            flash.message = "Profile updated"
        } else {
            flash.error = "Error updating profile"
        }

        redirect(controller: 'user', action: 'editprofile')
    }

    def updatePassword(){
        def user = session.user

        boolean updated = userService.changePassword(user, params)

        if (updated) {
            flash.message = "Profile updated"
        } else {
            flash.error = "Error updating profile"
        }

        redirect(controller: 'user', action: 'editprofile')
    }

    def dashboard(String q){
        if (!session.user) {
            flash.message = "You need to log in to access the dashboard."
            redirect(controller: 'home', action: 'index')
            return
        }
        AppUser user = session.user

        int countResource = AppResource.countByCreatedBy(user)
        int subscriptionCount = Subscription.countByUser(user)
        def topics = Topic.findAllByCreatedBy(user)
        def subscriptions = Subscription.findAllByUser(user)
        def trendingTopics = topicService.getTrendingTopics()

        render(view: "dashboard",model: [
            count: countResource,
            subscriptionCount: subscriptionCount,
            topics: topics,
            subscriptions: subscriptions,
            trendingTopics: trendingTopics
        ])
    }

    def refreshSubscriptions() {
        AppUser user = session.user
        if (!user) {
            render status: 401, text: "User not logged in"
            return
        }

        def subscriptions = Subscription.createCriteria().list(max: 5) {
            eq('user', user)
            topic {
                resources {
                    order('dateCreated', 'desc')
                }
            }
        }
        render template: '/user/subscription', model: [subscriptions: subscriptions]
    }

    def refreshInbox() {
        AppUser user = session.user
        String search = params.search ?: ""
        int max = Math.min(params.int('max') ?: 20, 100)
        int offset = params.int('offset') ?: 0
        
        def inboxResult = resourceService.getInbox(user, search, max, offset)
        
        render template: '/user/inbox', model: [
            inboxItem: inboxResult.resources,
            inboxCount: inboxResult.count,
            offset: offset,
            max: max
        ]
    }
    
    def inboxAjax() {
        AppUser user = session.user
        String search = params.search ?: ""
        int max = Math.min(params.int('max') ?: 20, 100)
        int offset = params.int('offset') ?: 0
        
        def inboxResult = resourceService.getInbox(user, search, max, offset)
        
        render template: '/user/inbox', model: [
            inboxItem: inboxResult.resources,
            inboxCount: inboxResult.count,
            offset: offset,
            max: max
        ]
    }

    def refreshTopics() {
        AppUser user = session.user
        if (!user) {
            render status: 401, text: "User not logged in"
            return
        }

        def trendingTopics = topicService.getTrendingTopics()
        render(template: '/user/refreshTopics', model: [trendingTopics: trendingTopics])
    }

    def search(String q){
        if(!session.user){
            flash.message = "Login to see search page"
            redirect(controller: 'home', action: 'index')
            return
        }

        List<Topic> trendingTopics = topicService.getTrendingTopics()
        List<AppResource> topPosts = resourceService.getLatestPublicResources()
        def topics = Topic.findAllByCreatedBy(session.user)

        render(view : "search", model: [
                trendingTopics: trendingTopics,
                topPosts: topPosts,
                q: q,
                topics: topics
        ])
    }
    
    def searchAjax() {
        if(!session.user){
            render status: 401, text: "Unauthorized"
            return
        }
        
        String q = params.q?.trim()
        int max = Math.min(params.int('max') ?: 10, 50) // Limit results per page
        int offset = params.int('offset') ?: 0
        
        // Get paginated search results
        def searchCriteria = AppResource.createCriteria()
        def searchResults = searchCriteria.list(max: max, offset: offset) {
            or {
                topic {
                    ilike('name', "%${q}%")
                }
                ilike('description', "%${q}%")
            }
            order('dateCreated', 'desc')
        }
        
        // Get total count for pagination
        def totalCount = AppResource.createCriteria().count {
            or {
                topic {
                    ilike('name', "%${q}%")
                }
                ilike('description', "%${q}%")
            }
        }
        
        render template: '/user/searchPost', model: [
            search: searchResults,
            searchCount: totalCount,
            offset: offset,
            max: max,
            q: q
        ]
    }
    
    def searchPagination() {
        if(!session.user){
            render status: 401, text: "Unauthorized"
            return
        }
        
        String q = params.q?.trim()
        int max = Math.min(params.int('max') ?: 10, 50)
        int offset = params.int('offset') ?: 0
        
        // Get total count for pagination
        def totalCount = AppResource.createCriteria().count {
            or {
                topic {
                    ilike('name', "%${q}%")
                }
                ilike('description', "%${q}%")
            }
        }
        
        int totalPages = totalCount > 0 ? (totalCount / max) + ((totalCount % max) > 0 ? 1 : 0) : 1
        int currentPage = (offset / max) + 1
        
        render template: '/user/searchPagination', model: [
            searchCount: totalCount,
            offset: offset,
            max: max,
            q: q,
            totalPages: totalPages,
            currentPage: currentPage
        ]
    }

    def refreshTrendingTopics() {
        try {
            def trendingTopics = Topic.list()

            render(contentType: 'application/json') {
                [
                        success: true,
                        html: g.render(template: '/dashboard/trendingTopicsContent', model: [trendingTopics: trendingTopics])
                ]
            }
        } catch (Exception e) {
            log.error("Error refreshing trending topics: ${e.message}", e)
            render(contentType: 'application/json') {
                [success: false, message: 'Failed to refresh data']
            }
        }
    }

    def photo() {
        Long userId = params.long("id")
        if (!userId) {
            response.sendError(400, "User ID is missing")
            return
        }

        AppUser user = AppUser.get(userId)

        if (user?.photo) {
            response.contentType = 'image/jpeg'
            response.setContentLength(user.photo.length)
            response.outputStream.write(user.photo)
            response.outputStream.flush()
            response.outputStream.close()

        } else {
            response.sendRedirect('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&s')
        }
    }

    def ajaxSubscribe() {
        def topicId = params.topicId
        def user = session.user

        if (!topicId || !user) {
            render([success: false, message: 'Invalid request parameters'] as JSON)
            return
        }

        def topic = Topic.get(topicId)
        if (!topic) {
            render([success: false, message: 'Topic not found'] as JSON)
            return
        }

        def existingSubscription = Subscription.findByUserAndTopic(user, topic)
        if (existingSubscription) {
            render([success: false, message: 'Already subscribed'] as JSON)
            return
        }

        def subscription = new Subscription(user: user, topic: topic)
        if (subscription.save(flush: true)) {
            // Get updated subscription count
            def updatedSubCount = Subscription.countByTopic(topic)
            render([
                success: true, 
                message: 'Successfully subscribed', 
                subCount: updatedSubCount
            ] as JSON)
        } else {
            render([success: false, message: 'Failed to subscribe: ' + subscription.errors] as JSON)
        }
    }

    def ajaxUnsubscribe() {
        def topicId = params.topicId
        def user = session.user
        
        if (!topicId || !user) {
            render([success: false, message: 'Invalid request parameters'] as JSON)
            return
        }
        
        def topic = Topic.get(topicId)
        if (!topic) {
            render([success: false, message: 'Topic not found'] as JSON)
            return
        }
        
        def subscription = Subscription.findByUserAndTopic(user, topic)
        if (!subscription) {
            render([success: false, message: 'Not subscribed'] as JSON)
            return
        }
        if( subscription.user.id != user.id) {
            render([success: false, message: 'Not authorized to unsubscribe'] as JSON)
            return
        }
        
        try {
            subscription.delete(flush: true)
            // Get updated subscription count
            def updatedSubCount = Subscription.countByTopic(topic)
            render([
                success: true, 
                message: 'Successfully unsubscribed', 
                subCount: updatedSubCount
            ] as JSON)
        } catch (Exception e) {
            log.error("Unsubscribe error: ${e.message}", e)
            render([success: false, message: 'Failed to unsubscribe: ' + e.message] as JSON)
        }
    }

    def mySubscriptions(Integer max, Integer offset, String sort, String orderParam, String search, String visibility) {
        AppUser user = session.user
        max = max ?: 10
        offset = offset ?: 0
        sort = sort ?: "id"
        orderParam = orderParam ?: "asc"

        def subscriptions = com.example.Subscription.findAllByUser(user)
        def topicIds = subscriptions*.topic.id
        def criteria = com.example.Topic.createCriteria()
        def topics = criteria.list(max: max, offset: offset) {
            if (topicIds) {
                'in'("id", topicIds)
            } else {
                eq("id", -1L) // No topics if not subscribed to any
            }
            if (search) {
                ilike("name", "%${search}%")
            }
            if (visibility) {
                // Parse the visibility parameter to the enum
                try {
                    eq("visibility", com.example.Visibility.valueOf(visibility))
                } catch (IllegalArgumentException e) {
                    // Invalid visibility value, ignore filter
                }
            }
            if (sort && orderParam && ["asc", "desc"].contains(orderParam.toLowerCase())) {
                order(sort, orderParam)
            }
        }
        def totalTopics = topics.size()
        render(view: "/resource/allTopics", model: [
            topics: topics,
            totalTopics: totalTopics,
            max: max,
            offset: offset,
            params: params
        ])
    }

    def myTopics(Integer max, Integer offset, String sort, String orderParam, String search, String visibility) {
        AppUser user = session.user
        max = max ?: 10
        offset = offset ?: 0
        sort = sort ?: "id"
        orderParam = orderParam ?: "asc"

        def criteria = Topic.createCriteria()
        def topics = criteria.list(max: max, offset: offset) {
            eq("createdBy", user)
            if (search) {
                ilike("name", "%${search}%")
            }
            if (visibility) {
                // Parse the visibility parameter to the enum
                try {
                    eq("visibility", com.example.Visibility.valueOf(visibility))
                } catch (IllegalArgumentException e) {
                    // Invalid visibility value, ignore filter
                }
            }
            if (sort && orderParam && ["asc", "desc"].contains(orderParam.toLowerCase())) {
                order(sort, orderParam)
            }
        }
        def totalTopics = topics.size()

        render(view: "/resource/allTopics", model: [
            topics: topics,
            totalTopics: totalTopics,
            max: max,
            offset: offset,
            params: params
        ])
    }

}
