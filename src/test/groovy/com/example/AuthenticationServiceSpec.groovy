package com.example

import grails.testing.services.ServiceUnitTest
import spock.lang.Specification

class AuthenticationServiceSpec extends Specification implements ServiceUnitTest<AuthenticationService> {

     void "test something"() {
        expect:
        service.doSomething()
     }
}
