package com.example

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class ReadingItemSpec extends Specification implements DomainUnitTest<ReadingItem> {

     void "test domain constraints"() {
        when:
        ReadingItem domain = new ReadingItem()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
