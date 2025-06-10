package com.example

class LinkResource extends AppResource {

    String url
    static constraints = {
        url(url: true, nullable: false)
    }
}

