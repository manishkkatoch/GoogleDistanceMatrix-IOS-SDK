import Foundation

public enum Result<T, U: Error> {
    case success(T)
    case failure(U)
    
    public var value: T? {
        switch self {
        case .success(let value):
            return value
        case .failure(_):
            return nil
        }
    }
    
    public var error: U? {
        switch self {
        case .success(_):
            return nil
        case .failure(let error):
            return error
        }
    }

    public init(value: T?, error: @autoclosure () -> U) {
        if let value = value {
            self = .success(value)
        } else {
            self = .failure(error())
        }
    }
}
