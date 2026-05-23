import Foundation

public enum MacrosAccess: String, Codable, Hashable, Sendable {
    case forbid = "MACROS_ACCESS_FORBID"
    case full = "MACROS_ACCESS_FULL"
}
