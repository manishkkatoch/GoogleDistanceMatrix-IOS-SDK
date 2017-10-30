import Foundation

public struct GDMAPIError: Error {
    public let message: String?
    
    static let UnknownError = GDMAPIError("UnknownError")
    
    init(_ message: String) {
        self.message = message
    }
    
    init?(responseType: ResponseType) {
        if responseType == .OK {
            return nil
        }
        self.message = responseType.rawValue
    }
}
