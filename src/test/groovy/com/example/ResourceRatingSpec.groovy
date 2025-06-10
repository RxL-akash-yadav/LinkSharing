package com.example

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class ResourceRatingSpec extends Specification implements DomainUnitTest<ResourceRating> {

     void "test domain constraints"() {
        when:
        ResourceRating domain = new ResourceRating()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
