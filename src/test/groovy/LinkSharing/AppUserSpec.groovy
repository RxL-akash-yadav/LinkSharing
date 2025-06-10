package LinkSharing

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class AppUserSpec extends Specification implements DomainUnitTest<AppUser> {

     void "test domain constraints"() {
        when:
        AppUser domain = new AppUser()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
