import Foundation

enum TwitterAPIError: ErrorType {
    case ConnectionError(NSError)
    case ResponseBodyDeserializationError(NSError)
    case InvalidResponseStructure(AnyObject)
    case UnacceptableStatusCode(Int, ErrorType)
}
