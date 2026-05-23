import Foundation

public enum AcfaAccess: String, Codable, Hashable, Sendable {
    case unspecified = "ACFA_ACCESS_UNSPECIFIED"
    case forbid = "ACFA_ACCESS_FORBID"
    case view = "ACFA_ACCESS_VIEW"
    case viewManage = "ACFA_ACCESS_VIEW_MANAGE"
    case viewManageConfigure = "ACFA_ACCESS_VIEW_MANAGE_CONFIGURE"
}
