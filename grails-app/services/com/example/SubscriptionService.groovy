package com.example

import grails.gorm.transactions.Transactional

@Transactional
class SubscriptionService {

    def subscribeUser(AppUser user, Topic topic) {
        if (!Subscription.findByUserAndTopic(user, topic)) {
            new Subscription(user: user, topic: topic).save(flush: true)
        }
    }

    def unsubscribeUser(AppUser user, Topic topic) {
        def subscription = Subscription.findByUserAndTopic(user, topic)
        if (subscription) {
            subscription.delete(flush: true)
        }
    }

}
