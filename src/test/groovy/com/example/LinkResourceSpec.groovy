package com.example

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class LinkResourceSpec extends Specification implements DomainUnitTest<LinkResource> {

     void "test domain constraints"() {
        when:
        LinkResource domain = new LinkResource()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
