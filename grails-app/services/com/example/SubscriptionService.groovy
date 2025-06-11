package com.example

import grails.gorm.transactions.Transactional

@Transactional
class SubscriptionService {


    /**
     * Subscribes a user to a topic with a specified seriousness level.
     * If the user is already subscribed, an exception is thrown.
     *
     * @param user The AppUser to subscribe
     * @param topic The Topic to subscribe to
     * @param seriousness The seriousness level of the subscription (default is "CASUAL")
     * @throws IllegalArgumentException if user or topic is null, or if the user is already subscribed
     */
    def subscribeUser(AppUser user, Topic topic, String seriousness = "CASUAL") {
        if(!user || !topic) {
            throw new IllegalArgumentException("User and Topic must not be null")
        }
        if(Subscription.findByUserAndTopic(user, topic)) {
            throw new IllegalArgumentException("User is already subscribed to this topic")
        }

        new Subscription(user: user, topic: topic,seriousness: seriousness).save(flush: true)
    }

    /**
     * Unsubscribes a user from a topic.
     * If the user is not subscribed, an exception is thrown.
     *
     * @param user The AppUser to unsubscribe
     * @param topic The Topic to unsubscribe from
     * @throws IllegalArgumentException if user or topic is null, or if the user is not subscribed
     */
    def unsubscribeUser(AppUser user, Topic topic) {
        if(!user || !topic) {
            throw new IllegalArgumentException("User and Topic must not be null")
        }
        if(!Subscription.findByUserAndTopic(user, topic)) {
            throw new IllegalArgumentException("User is not subscribed to this topic")
        }
        def subscription = Subscription.findByUserAndTopic(user, topic)
        if (subscription) {
            subscription.delete(flush: true)
        }
    }

}
