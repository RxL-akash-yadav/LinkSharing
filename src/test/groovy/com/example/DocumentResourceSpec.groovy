package com.example

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class DocumentResourceSpec extends Specification implements DomainUnitTest<DocumentResource> {

     void "test domain constraints"() {
        when:
        DocumentResource domain = new DocumentResource()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
