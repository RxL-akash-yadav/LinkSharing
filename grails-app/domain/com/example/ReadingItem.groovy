package com.example

class ReadingItem {
    AppResource resource
    AppUser user
    boolean isRead

    static belongsTo = [resource: AppResource, user: AppUser]

    static constraints = {
        resource(nullable: false)
        user(nullable: false)
        isRead(nullable: false)
    }
}
