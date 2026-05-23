import Foundation

public enum MapAccess: String, Codable, Hashable, Sendable {
    case unspecified = "MAP_ACCESS_UNSPECIFIED"
    case forbid = "MAP_ACCESS_FORBID"
    case viewOnly = "MAP_ACCESS_VIEW_ONLY"
    case viewScale = "MAP_ACCESS_VIEW_SCALE"
    case full = "MAP_ACCESS_FULL"
}
