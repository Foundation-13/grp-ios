import Foundation
import PromiseKit

protocol PlacesProvider {
    func placesBy(points: Places.SearchByPointsReq) -> Promise<Places.SearchByPointsResult>
}

// MARK:- PlacesService

final class PlacesService {
    
    init(executor: RequestExecutor) {
        self.executor = executor
    }

    private let executor: RequestExecutor
    
    final class SearchByPoints: JsonRequest<Places.SearchByPointsReq> {
        init(points: Places.SearchByPointsReq) {
            super.init(endpoint: "/api/v1/places/search/points", method: .post, body: points)
        }
    }
}

extension PlacesService: PlacesProvider {
    func placesBy(points: Places.SearchByPointsReq) -> Promise<Places.SearchByPointsResult> {
        return executor.run(request: SearchByPoints(points: points))
    }
}
