package LinkSharing

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class ResourceControllerSpec extends Specification implements ControllerUnitTest<ResourceController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
