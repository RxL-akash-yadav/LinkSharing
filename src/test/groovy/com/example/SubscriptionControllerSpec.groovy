package com.example

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class SubscriptionControllerSpec extends Specification implements ControllerUnitTest<SubscriptionController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
