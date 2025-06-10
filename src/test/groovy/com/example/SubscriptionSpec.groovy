package com.example

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class SubscriptionSpec extends Specification implements DomainUnitTest<Subscription> {

     void "test domain constraints"() {
        when:
        Subscription domain = new Subscription()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
