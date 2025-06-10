package com.example

class Topic {
    String name
    AppUser createdBy
    Date dateCreated
    Date lastUpdated
    Visibility visibility = Visibility.PUBLIC

    static hasMany = [
            subscriptions: Subscription,
            resources: AppResource
    ]

    static belongsTo = [createdBy: AppUser]


    static mapping = {
        subscriptions cascade: 'all-delete-orphan'
        resources cascade: 'all-delete-orphan'
    }

    static constraints = {
        name(nullable: false)
        createdBy(nullable: false)
        visibility(nullable: false)
    }
    
    int getSubscriptionCount() {
        return subscriptions?.size() ?: 0
    }

    int getPostCount() {
        return resources?.size() ?: 0
    }
}
