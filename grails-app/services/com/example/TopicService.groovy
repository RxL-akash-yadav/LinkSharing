package com.example

import grails.gorm.transactions.Transactional
import grails.validation.ValidationException



@Transactional
class TopicService {

    /**
     * Creates a new topic with the given name and visibility.
     * Throws IllegalArgumentException if visibility is invalid.
     * Throws ValidationException if topic validation fails.
     *
     * @param name The name of the topic
     * @param visibility The visibility of the topic (e.g., PUBLIC, PRIVATE)
     * @param currentUser The user creating the topic
     * @return The created Topic object
     */
    def createTopic(String name, String visibility, AppUser currentUser) {
        if (!Visibility.values()*.name().contains(visibility?.toUpperCase())) {
            throw new IllegalArgumentException("Invalid visibility value")
        }

        Topic topic = new Topic(
                name: name?.trim(),
                visibility: Visibility.valueOf(visibility.toUpperCase()),
                createdBy: currentUser
        )

        if (!topic.validate()) {
            throw new ValidationException("Validation failed", topic.errors)
        }

        topic.save(flush: true, failOnError: true)
        return topic
    }

    /**
     * Retrieves the top 5 trending topics based on the number of resources associated with them.
     *
     * @return A list of Topic objects representing the top trending topics
     */
    def getTrendingTopics() {
        def topTopicIds = AppResource.createCriteria().list {
            projections {
                groupProperty("topic.id")
                count("id", "resourceCount")
            }
            order("resourceCount", "desc")
            maxResults(5)
        }.collect { it[0] }

        def topTopics = Topic.getAll(topTopicIds)
        return topTopics
    }

}