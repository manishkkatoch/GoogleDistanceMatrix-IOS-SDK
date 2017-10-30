import Foundation

enum ResponseType: String {
    case OK,
        INVALID_REQUEST,
        MAX_ELEMENTS_EXCEEDED,
        OVER_QUERY_LIMIT,
        REQUEST_DENIED,
        UNKNOWN_ERROR
    
    static func fromStatusMessage(_ status: String) -> ResponseType {
        return ResponseType.init(rawValue: status) ?? .UNKNOWN_ERROR
    }
}

public enum HttpMethod: String {
    case get, put, post
}

final class HttpClient {
    
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func request(_ url: String, _ method: HttpMethod = HttpMethod.get,  parameters: [String: Any]? = nil,
                 completion: @escaping (Any?, ResponseType) -> Void)
    {
        if let url = URL(string: url) {
            let request = self.urlRequest(url: url, method: method, parameters: parameters)
            let dataTask = self.session.dataTask(with: request) { data, response, error in

                let JSON = try? JSONSerialization.jsonObject(with: data ?? Data(), options: [])
                var status = ResponseType.UNKNOWN_ERROR
                
                if let json = JSON as? [String: Any],
                   let statusCode = json["status"] as? String {
                    status = ResponseType.fromStatusMessage(statusCode)
                }
                
                DispatchQueue.main.async {
                    completion(JSON, status)
                }
            }
            dataTask.resume()
        }
    }
    
    private func urlRequest(url: URL, method: HttpMethod, parameters: [String: Any]? = nil) -> URLRequest
    {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return encodeUrl(request: request, parameters: parameters)
    }
    
    private func encodeUrl(request: URLRequest, parameters: [String: Any]?) -> URLRequest {
        guard let parameters = parameters else {
            return request
        }
        let queryParams = parameters.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        components?.queryItems = components?.queryItems ?? [] + queryParams
        
        var mutableRequest = request
        mutableRequest.url = components?.url
        return mutableRequest
    }

    
    
}
