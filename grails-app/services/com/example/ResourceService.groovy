package com.example

import grails.gorm.transactions.Transactional
import grails.validation.ValidationException
import org.springframework.web.multipart.MultipartFile



@Transactional
class ResourceService {

    def grailsApplication

    /**
     * Creates a new link resource and associates it with the specified topic.
     * Also creates reading items for all users subscribed to the topic.
     *
     * @param url The URL of the link resource
     * @param description A description of the resource
     * @param topicId The ID of the topic to associate with
     * @return The created LinkResource object
     * @throws ValidationException if the topic ID is invalid or if saving fails
     */
    LinkResource createResourceLink(String url, String description, Long topicId) {
        Topic topic = Topic.get(topicId)
        if (!topic) {
            throw new ValidationException("Invalid topic ID: ${topicId}")
        }

        AppUser user = topic.createdBy

        LinkResource resource = new LinkResource(
                url: url,
                description: description,
                topic: topic,
                createdBy: user
        )

        resource.save(flush: true, failOnError: true)

        List<Subscription> subscriptions = Subscription.findAllByTopic(topic)
        if(subscriptions.isEmpty()) return resource
        subscriptions.each { Subscription subscription ->
            AppUser subscribedUser = subscription.user
            ReadingItem readingItem = new ReadingItem(
                    resource: resource,
                    user: subscribedUser,
                    isRead: false
            )
            readingItem.save(flush: true, failOnError: true)
        }

        return resource
    }


    /**
     * Creates a new document resource and associates it with the specified topic.
     * The file content is stored directly in the database as a BLOB.
     * Also creates reading items for all users subscribed to the topic.
     *
     * @param file The uploaded file (MultipartFile)
     * @param description A description of the resource
     * @param topicId The ID of the topic to associate with
     * @return The created DocumentResource object
     * @throws ValidationException if the topic ID is invalid or if saving fails
     */
    DocumentResource createResourceDocument(MultipartFile file, String description, Long topicId) {
        Topic topic = Topic.get(topicId)
        if (!topic) {
            throw new ValidationException("Invalid topic ID: ${topicId}")
        }

        AppUser user = topic.createdBy

        String originalFileName = file.originalFilename
        String fileName = System.currentTimeMillis() + "_" + originalFileName
        
        // Store file content directly in the database as BLOB
        byte[] fileContent = file.bytes

        // Generate a unique file hash for shareDownload
        String fileHash = UUID.randomUUID().toString()

        DocumentResource documentResource = new DocumentResource(
                url: fileName,  // We still need URL for compatibility
                description: description,
                topic: topic,
                createdBy: user,
                fileName: fileName,
                contentType: file.contentType,
                fileHash: fileHash,
                fileContent: fileContent  // Store the actual file content
        )

        if (!documentResource.save(flush: true)) {
            throw new ValidationException("Failed to save document", documentResource.errors)
        }

        List<Subscription> subscriptions = Subscription.findAllByTopic(topic)
        if(subscriptions.isEmpty()) return documentResource
        subscriptions.each { Subscription subscription ->
            AppUser subscribedUser = subscription.user
            ReadingItem readingItem = new ReadingItem(
                    resource: documentResource,
                    user: subscribedUser,
                    isRead: false
            )
            readingItem.save(flush: true, failOnError: true)
        }
        return documentResource
    }




    def getInbox(AppUser user, String search, int max = 20, int offset = 0) {
        if (!user) {
            return [resources: [], count: 0]
        }

        def resources = AppResource.createCriteria().list(max: max, offset: offset) {
            topic {
                subscriptions {
                    eq("user", user)
                }
            }
            if (search) {
                or {
                    ilike("description", "%${search}%")
                    topic {
                        ilike("name", "%${search}%")
                    }
                }
            }
            readingItems {
                eq("user", user)
                eq("isRead", false)
            }
            order('dateCreated', 'desc')
        }

        def count = AppResource.createCriteria().count {
            topic {
                subscriptions {
                    eq("user", user)
                }
            }
            if (search) {
                or {
                    ilike("description", "%${search}%")
                    topic {
                        ilike("name", "%${search}%")
                    }
                }
            }
            readingItems {
                eq("user", user)
                eq("isRead", false)
            }
        }

        return [resources: resources, count: count]
    }


    def updateResourceLink(Long id, String url, String description) {
        LinkResource resource = LinkResource.get(id)
        if (!resource) {
            throw new RuntimeException("Link resource not found")
        }

        resource.url = url
        resource.description = description
        resource.save(failOnError: true)
    }

    def updateResourceDocument(Long id, MultipartFile file, String description) {
        DocumentResource resource = DocumentResource.get(id)
        if (!resource) {
            throw new RuntimeException("Document resource not found")
        }

        if (file && !file.empty) {
            String uploadDir = grailsApplication.config.file.upload.dir ?: "uploads/"
            String newPath = uploadDir + file.originalFilename
            file.transferTo(new File(newPath))
            resource.filepath = newPath
        }

        resource.description = description
        resource.save(failOnError: true)
    }


    List<AppResource> getTopRatedPublicResources() {
        return AppResource.createCriteria().list {
            createAlias('topic', 't')
            eq('t.visibility', Visibility.PUBLIC)
            order('dateCreated', 'desc')
            maxResults(3)
        }
    }

    List<AppResource> getLatestPublicResources() {
        AppResource.createCriteria().list {
            createAlias('topic', 't')
            eq('t.visibility', Visibility.PUBLIC)
            order('dateCreated', 'desc')
            maxResults(5)
        }
    }
    // For link
    void updateResourceLink(Long resourceId, String url, String description, Long topicId) {
        def resource = AppResource.get(resourceId)
        resource.url = url
        resource.description = description
        resource.topic = Topic.get(topicId)
        resource.save(flush: true, failOnError: true)
    }

    // For document - updated to handle file uploads directly to BLOB
    void updateResourceDocument(Long resourceId, MultipartFile file, String description, Long topicId) {
        def resource = DocumentResource.get(resourceId)
        if (!resource) {
            throw new ValidationException("Document resource not found")
        }
        
        // Update description
        resource.description = description
        
        // If new topic provided, update it
        if (topicId) {
            Topic newTopic = Topic.get(topicId)
            if (newTopic) {
                resource.topic = newTopic
            }
        }
        
        // If new file provided, update it
        if (file && !file.empty) {
            String originalFileName = file.originalFilename
            String fileName = System.currentTimeMillis() + "_" + originalFileName
            
            // Update file details and content
            resource.fileName = fileName
            resource.url = fileName
            resource.contentType = file.contentType
            resource.fileContent = file.bytes  // Store file content as BLOB
        }
        
        resource.save(flush: true, failOnError: true)
    }



}