import Foundation

public enum AlertAccess: String, Codable, Hashable, Sendable {
    case unspecified = "ALERT_ACCESS_UNSPECIFIED"
    case forbid = "ALERT_ACCESS_FORBID"
    case viewOnly = "ALERT_ACCESS_VIEW_ONLY"
    case full = "ALERT_ACCESS_FULL"
}
