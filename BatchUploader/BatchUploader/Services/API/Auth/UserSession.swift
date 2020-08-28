import Foundation
import PromiseKit

struct AuthToken {
    let token: String
    let provider: String
    let expired: Date

    var bearer: String { return "Bearer \(token)" }
}

final class UserSession {
    func getToken() -> Promise<AuthToken> {
        return Promise.value(AuthToken(token: "123", provider: "custom", expired: Date()))
    }
}

