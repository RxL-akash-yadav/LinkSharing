package com.example

class AppResource {
    String description
    AppUser createdBy
    Topic topic
    Date dateCreated
    Date lastUpdated

    static belongsTo = [createdBy: AppUser, topic: Topic]

    static hasMany = [
            readingItems: ReadingItem,
            resourceRatings: ResourceRating
    ]

    static mapping = {
        table : 'APP_RESOURCE'
    }


    static constraints = {
        description(nullable: false)
        createdBy(nullable: false)
        topic(nullable: false)
    }
}
