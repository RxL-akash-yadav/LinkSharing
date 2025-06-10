package com.example

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class AppResourceSpec extends Specification implements DomainUnitTest<AppResource> {

     void "test domain constraints"() {
        when:
        AppResource domain = new AppResource()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
