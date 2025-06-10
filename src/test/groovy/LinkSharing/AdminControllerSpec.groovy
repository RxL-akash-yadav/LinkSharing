package LinkSharing

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class AdminControllerSpec extends Specification implements ControllerUnitTest<AdminController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
