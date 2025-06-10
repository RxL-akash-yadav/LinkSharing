package LinkSharing

import com.example.AppResource
import com.example.AppUser
import com.example.DocumentResource
import com.example.LinkResource
import com.example.ReadingItem
import com.example.ResourceRating
import com.example.ResourceService
import com.example.Subscription
import com.example.Topic
import com.example.TopicService
import grails.converters.JSON
import grails.gorm.transactions.Transactional
import org.springframework.security.access.annotation.Secured
import org.springframework.web.multipart.MultipartFile

@Transactional
@Secured(['permitAll'])
class ResourceController {

    static allowedMethods = [delete: 'GET']


    ResourceService resourceService
    TopicService topicService


    def post(Long id) {
        AppResource resource = AppResource.get(id)
        if (!resource) {
            flash.message = "Resource not found"
            redirect(controller: 'user', action: 'index')
            return
        }
        AppUser user = session.user

        List<Topic> topics = Topic.findAllByCreatedBy(user)

        List<Topic> trendingTopics = topicService.getTrendingTopics()

        render(view: "post", model: [resource: resource, topics: topics])
    }


    def deleteResource(Long id) {
        AppResource resource = AppResource.get(id)
        if (!resource) {
            render status: 404, text: 'Resource not found'
            return
        }
        try {
            resource.delete(flush: true)
            flash.message = 'Resource deleted successfully'
            redirect(controller: 'user', action: 'dashboard')
        } catch (Exception e) {
            log.error("Failed to delete resource: ${e.message}", e)
            render status: 500, text: 'Failed to delete resource'
        }
    }


    def editLink() {
        Long resourceId = params.long("resourceId")
        String url = params.link
        String description = params.description

        try {
            AppResource resource = AppResource.get(resourceId)
            if (!resource) {
                if (request.xhr) {
                    render([success: false, message: "Link resource not found"] as JSON)
                } else {
                    flash.error = "Link resource not found"
                    redirect(controller: "user", action: "dashboard")
                }
                return
            }

            resource.url = url
            resource.description = description
            resource.save(flush: true, failOnError: true)

            if (request.xhr) {
                render([
                    success: true,
                    message: "Link updated successfully!",
                    resource: [
                        id: resource.id,
                        url: resource.url,
                        description: resource.description
                    ]
                ] as JSON)
            } else {
                flash.message = "Link updated successfully!"
                redirect(controller: "resource", action: "post", id: resource.id)
            }
        } catch (Exception e) {
            if (request.xhr) {
                log.error("Error updating link", e)
                render([success: false, message: "Something went wrong while updating the link!"] as JSON)
            } else {
                flash.error = "Something went wrong while updating the link!"
                log.error("Error updating link", e)
                redirect(controller: "user", action: "dashboard")
            }
        }
    }


    def editDocument() {
        Long resourceId = params.long("resourceId")
        String description = params.description

        try {
            AppResource resource = AppResource.get(resourceId)
            if (!resource) {
                if (request.xhr) {
                    render([success: false, message: "Document resource not found"] as JSON)
                } else {
                    flash.error = "Document resource not found"
                    redirect(controller: "user", action: "dashboard")
                }
                return
            }

            resource.description = description
            resource.save(flush: true, failOnError: true)

            if (request.xhr) {
                render([
                    success: true,
                    message: "Document updated successfully!",
                    resource: [
                        id: resource.id,
                        description: resource.description
                    ]
                ] as JSON)
            } else {
                flash.message = "Document updated successfully!"
                redirect(controller: "resource", action: "post", id: resource.id)
            }
        } catch (Exception e) {
            if (request.xhr) {
                log.error("Error updating document", e)
                render([success: false, message: "Something went wrong while updating the document!"] as JSON)
            } else {
                flash.error = "Something went wrong while updating the document!"
                log.error("Error updating document", e)
                redirect(controller: "user", action: "dashboard")
            }
        }
    }

    def topic(Long id, String q) {

        if(!session.user){
            flash.message = "Login to see topic page"
            redirect(controller: 'home', action: 'index')
            return
        }


        Topic topic = Topic.get(id)
        if(topic.visibility== "PRIVATE" && !topic.createdBy.equals(session.user)){
            flash.message = "You don't have permission to view this topic"
            redirect(controller: 'home', action: 'dashboard')
            return
        }
        List<Subscription> subs = Subscription.findAllByTopic(topic)

        List<AppResource> posts

        if (q) {
            posts = AppResource.createCriteria().list {
                eq('topic', topic)
                ilike('description', "%${q}%")
            }
        } else {
            posts = AppResource.findAllByTopic(topic)
        }

        render(view: "topic", model: [
            topic: topic,
            posts: posts,
            subCount: subs.size(),
            postCount: posts.size(),
            query: q
        ])
    }

    def shareLink(){
        String url = params.link
        String description = params.description
        Long topicId = params.topicId as Long

        try {
            resourceService.createResourceLink(url, description, topicId)
            flash.message = "Resource created successfully!"
        } catch (Exception e) {
            flash.error = "Something went wrong while creating resource!"
            log.error("Error creating resource", e)
        }
        redirect(controller: "user", action: "dashboard")
    }

    def download(Long id) {
        DocumentResource resource = DocumentResource.get(id)

        if (!resource) {
            if (request.xhr) {
                render([success: false, error: "Document not found"] as JSON)
                return
            } else {
                flash.error = "Document not found"
                redirect(action: 'index')
                return
            }
        }

        try {
            // Use fileContent BLOB data instead of file system
            if (resource.fileContent == null || resource.fileContent.length == 0) {
                log.error("File content is empty for document: ${resource.id}")
                if (request.xhr) {
                    render([success: false, error: "File content is empty"] as JSON)
                    return
                } else {
                    flash.error = "File content is empty"
                    redirect(action: 'post', id: id)
                    return
                }
            }
            
            // Mark as read if user is logged in
            if (session.user) {
                try {
                    ReadingItem readingItem = ReadingItem.findByUserAndResource(session.user, resource)
                    if (!readingItem) {
                        readingItem = new ReadingItem(user: session.user, resource: resource, isRead: true)
                    } else {
                        readingItem.isRead = true
                    }
                    readingItem.save(flush: true)
                } catch (Exception e) {
                    log.error("Error marking as read: ${e.message}", e)
                }
            }
            
            if (request.xhr) {
                def responseData = [
                    success: true,
                    downloadUrl: createLink(action: 'downloadFile', id: id, absolute: true)
                ]

                if (resource.fileName) {
                    responseData.fileName = resource.fileName
                } else {
                    responseData.fileName = "document-${id}.bin"
                }
                
                render responseData as JSON
                return
            } else {
                // For regular requests, stream the BLOB data directly
                response.setContentType(determineContentType(resource.fileName ?: "application/octet-stream"))
                
                // Ensure fileName is not null for Content-disposition header
                String safeFileName = resource.fileName ?: "document-${id}.bin"
                response.setHeader("Content-disposition", "attachment;filename=\"${safeFileName}\"")
                
                response.setContentLength(resource.fileContent.length)
                
                OutputStream out = response.outputStream
                out << resource.fileContent
                out.flush()
                out.close()
                return
            }
        } catch (Exception e) {
            log.error("Error downloading file: ${e.message}", e)
            if (request.xhr) {
                render([success: false, error: "Error downloading file: ${e.message}"] as JSON)
            } else {
                flash.error = "Error downloading file: ${e.message}"
                redirect(action: 'post', id: id)
            }
        }
    }

    def downloadFile(Long id) {
        DocumentResource resource = DocumentResource.get(id)
        
        if (!resource) {
            flash.error = "Document not found"
            redirect(action: 'index')
            return
        }
        
        try {
            if (resource.fileContent == null || resource.fileContent.length == 0) {
                log.error("File content is empty for document: ${resource.id}")
                flash.error = "File content is empty"
                redirect(action: 'post', id: id)
                return
            }

            response.setContentType(determineContentType(resource.fileName ?: "application/octet-stream"))

            String safeFileName = resource.fileName ?: "document-${id}.bin"
            response.setHeader("Content-disposition", "attachment;filename=\"${safeFileName}\"")
            
            response.setContentLength(resource.fileContent.length)
            
            OutputStream out = response.outputStream
            out << resource.fileContent
            out.flush()
            out.close()
            return
        } catch (Exception e) {
            log.error("Error downloading file: ${e.message}", e)
            flash.error = "Error downloading file: ${e.message}"
            redirect(action: 'post', id: id)
        }
    }

    private String determineContentType(String fileName) {
        String extension = fileName.lastIndexOf('.') > 0 ? 
                           fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase() : ""
        
        switch (extension) {
            case "pdf": return "application/pdf"
            case "doc": return "application/msword"
            case "docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            case "xls": return "application/vnd.ms-excel"
            case "xlsx": return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            case "ppt": return "application/vnd.ms-powerpoint"
            case "pptx": return "application/vnd.openxmlformats-officedocument.presentationml.presentation"
            case "jpg":
            case "jpeg": return "image/jpeg"
            case "png": return "image/png"
            case "gif": return "image/gif"
            case "txt": return "text/plain"
            default: return "application/octet-stream"
        }
    }

    def shareDocument() {
        MultipartFile file = request.getFile("filepath")
        String description = params.description
        Long topicId = params.long("topicId")

        if (!file || file.empty) {
            flash.error = "No file selected"
            redirect(controller: "user", action: "dashboard")
            return
        }

        try {
            resourceService.createResourceDocument(file, description, topicId)
            flash.message = "Document uploaded successfully!"
        } catch (Exception e) {
            flash.error = "Something went wrong while creating resource!"
            log.error("Error uploading document", e)
        }

        redirect(controller: "user", action: "dashboard")
    }


    @Transactional
    def markAsRead() {
        Long id
        
        if (request.JSON) {
            id = request.JSON.id as Long
        } else {
            id = params.long('id')
        }
        
        if (!id) {
            render([success: false, error: 'Resource ID is required'] as JSON)
            return
        }
        
        if (!request.xhr) {
            render([success: false, error: 'Only AJAX requests are supported'] as JSON)
            return
        }
        
        AppUser currentUser = session.user
        if (!currentUser) {
            render([success: false, error: "You must be logged in to perform this action."] as JSON)
            return
        }

        AppResource resource = AppResource.get(id)
        if (!resource) {
            render([success: false, error: "Resource not found."] as JSON)
            return
        }

        try {
            ReadingItem readingItem = ReadingItem.findByUserAndResource(currentUser, resource)
            if (!readingItem) {
                readingItem = new ReadingItem(
                    user: currentUser,
                    resource: resource,
                    isRead: true
                )
            } else {
                readingItem.isRead = true
            }
            
            if (readingItem.save(flush: true)) {
                // Get updated unread count for user
                def unreadCount = ReadingItem.countByUserAndIsRead(currentUser, false)
                
                render([
                    success: true, 
                    message: "Marked as read successfully.", 
                    resourceId: id,
                    isRead: true,
                    unreadCount: unreadCount
                ] as JSON)
            } else {
                render([success: false, error: "Failed to save reading item: ${readingItem.errors}"] as JSON)
            }
        } catch (Exception e) {
            log.error("Error marking resource as read: ${e.message}", e)
            render([success: false, error: "Failed to mark as read: ${e.message}"] as JSON)
        }
    }


    def allTopics() {
        if(!session.user) {
            flash.message = "Login to see all topics"
            redirect(controller: 'home', action: 'index')
            return
        }
        def sortField = params.sort ?: "id"
        def sortOrder = params.order ?: "asc"
        def max = params.int('max') ?: 10
        def offset = params.int('offset') ?: 0
        def search = params.search?.trim()
        def status = params.status

        def topics = Topic.createCriteria().list(max: max, offset: offset) {
            if (search) {
                ilike("name", "%${search}%")
            }

            if (status == "PUBLIC") {
                eq("visibility", "PUBLIC")
            } else if (status == "PRIVATE") {
                eq("visibility", "PRIVATE")
            }

            order(sortField, sortOrder)
        }

        def totalTopics = Topic.createCriteria().count {
            if (search) {
                ilike("name", "%${search}%")
            }

            if (status == "PUBLIC") {
                eq("visibility", "PUBLIC")
            } else if (status == "PRIVATE") {
                eq("visibility", "PRIVATE")
            }
        }

        render(view: "allTopics", model: [
                topics      : topics,
                totalTopics : totalTopics,
                max         : max,
                offset      : offset
        ])
    }


    def allResource(){
        if(!session.user) {
            flash.message = "Login to see all resources"
            redirect(controller: 'home', action: 'index')
            return
        }
        def sortField = params.sort ?: "id"
        def sortOrder = params.order ?: "asc"
        def max = params.int('max') ?: 10
        def offset = params.int('offset') ?: 0
        def search = params.search?.trim()

        def posts = AppResource.createCriteria().list(max: max, offset: offset) {
            if (search) {
                ilike("description", "%${search}%")
            }
            order(sortField, sortOrder)
        }

        def totalPosts = AppResource.createCriteria().count {
            if (search) {
                ilike("description", "%${search}%")
            }
        }
        render(view: "allResource", model: [
                posts      : posts,
                totalPosts : totalPosts,
                max         : max,
                offset      : offset
        ])
    }

    def rate() {
        AppUser user = session.user
        AppResource resource = AppResource.get(params.resourceId as Long)
        Integer score = params.int('score')

        if (user && resource && score >= 1 && score <= 5) {
            def rating = ResourceRating.findByUserAndResource(user, resource) ?: new ResourceRating(user: user, resource: resource)
            rating.score = score

            if (rating.save(flush: true)) {
                def ratings = ResourceRating.findAllByResource(resource)
                def totalRatings = ratings.size()
                def averageRating = totalRatings ? (ratings*.score.sum() / totalRatings).round(2) : 0

                render([
                        success: true,
                        averageRating: averageRating,
                        totalRatings: totalRatings,
                        userScore: score
                ] as JSON)
                return
            } else {
                response.status = 400
                render([success: false, message: 'Validation failed'] as JSON)
                return
            }
        }

        response.status = 400
        render([success: false, message: 'Invalid input'] as JSON)
    }

    def getUserRating(Long resourceId) {
        def user = session.user
        if (!user) {
            render([score: 0] as JSON)
            return
        }

        def rating = ResourceRating.findByUserAndResource(user, AppResource.get(resourceId))
        render([score: rating?.score ?: 0] as JSON)
    }

    def getRatingInfo(Long resourceId) {
        def resource = AppResource.get(resourceId)
        if (!resource) {
            response.status = 404
            render([error: 'Resource not found'] as JSON)
            return
        }

        def ratings = ResourceRating.findAllByResource(resource)
        def totalRatings = ratings.size()
        def averageRating = totalRatings ? (ratings*.score.sum() / totalRatings).round(2) : 0

        render([
                averageRating: averageRating,
                totalRatings: totalRatings
        ] as JSON)
    }

    def trendingTopics() {
        def topics = topicService.getTrendingTopics()

        render(template: '/resource/trendingTopics', model: [trendingTopics: topics])
    }

    def loadTopicUsersAjax() {
        Long topicId = params.long('topicId')
        int offset = params.int('offset') ?: 0
        int max = params.int('max') ?: 1

        Topic topic = Topic.get(topicId)
        if (!topic) {
            render status: 404
            return
        }

        List<AppUser> users = AppUser.createCriteria().list(max: max, offset: offset) {
            subscriptions {
                eq("topic", topic)
            }
            order("firstName", "asc")
        }

        int totalUsers = AppUser.createCriteria().get {
            subscriptions {
                eq("topic", topic)
            }
            projections {
                countDistinct("id")
            }
        }

        render template: "/resource/topicUserList", model: [users: users, topic: topic, offset: offset, max: max, totalUsers: totalUsers]
    }

    def topicPosts() {
        Long id = params.long('topicId')
        int offset = params.int('offset') ?: 0
        int max = params.int('max') ?: 5
        String q = params.q

        Topic topic = Topic.get(id)
        if (!topic) {
            render status: 404, text: 'Topic not found'
            return
        }

        def criteria = AppResource.createCriteria()
        def posts = criteria.list(max: max, offset: offset) {
            eq('topic', topic)
            if (q) {
                ilike('description', "%${q}%")
            }
        }

        int totalCount = AppResource.countByTopic(topic)

        render(template: 'topicPosts', model: [
                posts: posts,
                offset: offset,
                max: max,
                totalCount: totalCount
        ])
    }
}
