import Foundation

/// Superuser flag from global `unrestricted_access`.
public enum UnrestrictedAccess: String, Codable, Hashable, Sendable {
    case no = "UNRESTRICTED_ACCESS_NO"
    case yes = "UNRESTRICTED_ACCESS_YES"
}
