package LinkSharing

class UrlMappings {
    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{

        }
        "404"(view: '/error')
        "/"(controller: "home", action: "index")
        "/subscribe"(controller: "user", action: "subscribe", method: "POST")
        "/unsubscribe"(controller: "user", action: "unsubscribe", method: "POST")
        "/resource/markAsRead/$id"(controller: "resource", action: "markAsRead")
        "500"(view: '/error')
    }
}
