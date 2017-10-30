import Foundation
import CoreLocation

public enum GDMLocation {
    case Coordinates(location: CLLocationCoordinate2D)
    case Address(address: String)
    case Place(placeId: String)
    
    var description: String {
        switch self {
        case let .Coordinates(location):
            return "\(location.latitude.description),\(location.longitude.description)"
        case let .Address(address):
            return address
        case let .Place(placeId):
            return "place_id:\(placeId)"
        }
    }
}

public struct GDMAPI {
    static let baseUrl = "https://maps.googleapis.com/maps/api/distancematrix/json"
    static let client: HttpClient = {
        var configuration = URLSessionConfiguration.ephemeral
        return HttpClient(configuration: configuration)
    }()
    
    public static func getTimeDistance(from origin: GDMLocation,
                                  to destination: GDMLocation,
                                  parameters: GDMPParameters,
                                  completion: @escaping (Result<GDMResult, GDMAPIError>) -> Void) {
        
        var mutableParmeters = parameters.dictionary
        if let auth = GDMConfiguration.auth {
            mutableParmeters += auth.getAuthHeaders()
        }
        mutableParmeters["origins"] = origin.description
        mutableParmeters["destinations"] = destination.description
        
        self.client.request(self.baseUrl, parameters: mutableParmeters) {
            (response, status) in
            let response = response as? GDMDictionary
            let value = GDMResult(withDictionary: response)
            let error = GDMAPIError(responseType: status) ?? GDMAPIError.UnknownError
            completion(Result(value: value, error: error))
        }
    }
}

fileprivate func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}
