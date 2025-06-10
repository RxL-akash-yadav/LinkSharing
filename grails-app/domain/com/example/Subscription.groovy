package com.example

class Subscription {
    Topic topic
    AppUser user
    Seriousness seriousness = Seriousness.CASUAL
    Date dateCreated

    static belongsTo = [topic: Topic, user: AppUser]

    static constraints = {
        topic(nullable: false)
        user(nullable: false)
        seriousness(nullable: false)
    }
}