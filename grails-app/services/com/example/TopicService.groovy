package com.example

import grails.gorm.transactions.Transactional
import grails.validation.ValidationException



@Transactional
class TopicService {

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