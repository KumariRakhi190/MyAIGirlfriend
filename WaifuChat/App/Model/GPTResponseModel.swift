

import Foundation

// MARK: - PayPalPaymentModel
struct GPTResponseModel: Codable {
    var choices: [Choice]?
    var error: GPTError?
}

// MARK: - Choice
struct Choice: Codable {
    var message: GPTMessage?
}

// MARK: - GPTMessage
struct GPTMessage: Codable {
    var content: String?
    var role: Role?
}

struct GPTError: Codable{
    var message: String?
    var code: GPTErrorCode?
}

enum Role: String, Codable{
    case user
    case assistant
    case system
}

enum GPTErrorCode: String, Codable{
    case contextLengthExceeded = "context_length_exceeded"
    case rateLimitExceeded = "rate_limit_exceeded"
}
