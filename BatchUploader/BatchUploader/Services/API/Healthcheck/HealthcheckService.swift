import Foundation
import PromiseKit

protocol HealthcheckProvider {
    func healthcheck() -> Promise<Void>
}

// MARK:- Implementation
final class HealthcheckService {
    init(executor: RequestExecutor) {
        self.executor = executor
    }

    private let executor: RequestExecutor
    
    //MARK:- Requests
    private final class HealthcheckRequest: BaseRequest {
        init() {
            super.init(endpoint: "", method: .get, auth: .notRequired)
        }
    }
}

extension HealthcheckService: HealthcheckProvider {
    func healthcheck() -> Promise<Void> {
        return executor.run(request: HealthcheckRequest())
    }
}
