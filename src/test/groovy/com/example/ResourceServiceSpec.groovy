package com.example

import grails.testing.services.ServiceUnitTest
import spock.lang.Specification

class ResourceServiceSpec extends Specification implements ServiceUnitTest<ResourceService> {

     void "test something"() {
        expect:
        service.doSomething()
     }
}
