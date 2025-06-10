package LinkSharing

import grails.testing.web.interceptor.InterceptorUnitTest
import spock.lang.Specification

class AuthenticationInterceptorSpec extends Specification implements InterceptorUnitTest<AuthenticationInterceptor> {

    void "test interceptor matching"() {
        when:
        withRequest(controller: "authentication")

        then:
        interceptor.doesMatch()
    }
}
