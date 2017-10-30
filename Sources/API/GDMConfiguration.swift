import Foundation

fileprivate let QUERYPARAM_KEY = "key"
fileprivate let QUERYPARAM_CLIENTID = "clientId"
fileprivate let QUERYPARAM_SIGNATURE = "signature"

public enum Authentication {
    case ApiKey(apiKey: String)
    case ClientAuth(clientId: String, signature: String)
    
    func getAuthHeaders() -> [String: String] {
        switch(self) {
            case let .ApiKey(key):
                return [
                    QUERYPARAM_KEY: key
            ]
            case let .ClientAuth(clientId, signature):
                return [
                    QUERYPARAM_CLIENTID: clientId,
                    QUERYPARAM_SIGNATURE: signature
            ]
        }
    }
}

public struct GDMConfiguration {
    public static var auth: Authentication?
}

