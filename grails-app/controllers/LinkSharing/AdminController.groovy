package LinkSharing

import com.example.AppUser
import grails.gorm.transactions.Transactional
import org.springframework.security.access.annotation.Secured



@Secured(['permitAll'])
@Transactional
class AdminController {

    def users() {
        def sortField = params.sort ?: "id"
        def sortOrder = params.order ?: "asc"
        def max = params.int('max') ?: 20
        def offset = params.int('offset') ?: 0
        def search = params.search?.trim()
        def status = params.status

        def criteria = AppUser.createCriteria()
        def users = criteria.list(max: max, offset: offset) {
            eq("admin", false)

            if (search) {
                or {
                    ilike("username", "%${search}%")
                    ilike("email", "%${search}%")
                }
            }

            if (status == "active") {
                eq("active", true)
            } else if (status == "inactive") {
                eq("active", false)
            }

            order(sortField, sortOrder)
        }

        def totalCriteria = AppUser.createCriteria()
        def totalUsers = totalCriteria.count {
            eq("admin", false)

            if (search) {
                or {
                    ilike("username", "%${search}%")
                    ilike("email", "%${search}%")
                }
            }

            if (status == "active") {
                eq("active", true)
            } else if (status == "inactive") {
                eq("active", false)
            }
        }

        render(view: "users", model: [
                users      : users,
                totalUsers : totalUsers,
                max        : max,
                offset     : offset
        ])
    }



    def deactivate() {
        def user = AppUser.get(params.userId)
        if (user) {
            user.active = false
            user.save(flush: true)
            flash.message = "User deactivated successfully"
        }
        redirect(controller: "admin", action: "users")
    }

    def activate() {
        def user = AppUser.get(params.userId)
        if (user) {
            user.active = true
            user.save(flush: true)
            flash.message = "User activated successfully"
        }
        redirect(controller: "admin", action: "users")
    }
}