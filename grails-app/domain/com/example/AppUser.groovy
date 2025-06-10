package com.example

class AppUser {
    String email
    String username
    String password
    String firstName
    String lastName
    byte[] photo
    boolean admin
    boolean active
    Date dateCreated
    Date lastUpdated
    String resetToken
    Date resetTokenExpiry

    static hasMany = [
            subscriptions: Subscription,
            resources: AppResource,
            readingItems: ReadingItem,
            resourceRatings: ResourceRating
    ]

    static constraints = {
        email(email: true, nullable: false, unique: true)
        username(nullable: false, unique: true)
        password(nullable: false)
        firstName(nullable: false)
        lastName(nullable: false)
        photo(nullable: true, maxSize : 1024*1024*5)
        admin(nullable: false)
        active(nullable: false)
        resetToken(nullable: true)
        resetTokenExpiry(nullable: true)
    }
}