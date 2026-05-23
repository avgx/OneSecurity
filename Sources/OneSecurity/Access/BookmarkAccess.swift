import Foundation

public enum BookmarkAccess: String, Codable, Hashable, Sendable {
    case unspecified = "BOOKMARK_ACCESS_UNSPECIFIED"
    case no = "BOOKMARK_ACCESS_NO"
    case create = "BOOKMARK_ACCESS_CREATE"
    case createProtect = "BOOKMARK_ACCESS_CREATE_PROTECT"
    case createProtectEditDelete = "BOOKMARK_ACCESS_CREATE_PROTECT_EDIT_DELETE"
}
