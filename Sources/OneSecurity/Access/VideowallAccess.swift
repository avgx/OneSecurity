import Foundation

public enum VideowallAccess: String, Codable, Hashable, Sendable {
    case unspecified = "VIDEOWALL_ACCESS_UNSPECIFIED"
    case forbid = "VIDEOWALL_ACCESS_FORBID"
    case full = "VIDEOWALL_ACCESS_FULL"
}
