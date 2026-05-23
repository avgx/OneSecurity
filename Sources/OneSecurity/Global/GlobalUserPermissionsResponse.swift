import Foundation

/// Wire response for `GET /v1/security/permissions/global/user`.
///
/// Shape: `{ "permissions": { "<role-uuid>": { ...GlobalPermissions... } } }`.
public struct GlobalUserPermissionsResponse: Decodable, Equatable, Sendable {
    public let permissions: [String: GlobalPermissions]

    public init(permissions: [String: GlobalPermissions]) {
        self.permissions = permissions
    }

    /// First role permissions entry (typical single-role mobile session).
    public var firstRolePermissions: GlobalPermissions? {
        permissions.values.first
    }
}
