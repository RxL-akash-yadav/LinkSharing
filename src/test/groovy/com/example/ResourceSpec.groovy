package com.example

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class ResourceSpec extends Specification implements DomainUnitTest<Resource> {

     void "test domain constraints"() {
        when:
        Resource domain = new Resource()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
