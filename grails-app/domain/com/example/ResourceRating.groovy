package com.example

class ResourceRating {
    AppResource resource
    AppUser user
    Integer score

    static belongsTo = [resource: AppResource, user: AppUser]

    static constraints = {
        resource(nullable: false)
        user(nullable: false)
        score(nullable: false, min: 1, max: 5)
    }
}
