package com.example

import grails.testing.services.ServiceUnitTest
import spock.lang.Specification

class TopicServiceSpec extends Specification implements ServiceUnitTest<TopicService> {

     void "test something"() {
        expect:
        service.doSomething()
     }
}
