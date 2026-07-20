import Foundation
import RequestResponse

/// Security API (`v1/security/*`).
public enum SecurityApi {
    /// Endpoint: `GET /v1/security/permissions/global/user`
    ///
    /// Returns a typed JSON request (not SSE/multipart). Decode via `HTTPClient.send`.
    public static func globalUserPermissions() -> Request<GlobalUserPermissionsResponse> {
        Request(
            path: "v1/security/permissions/global/user",
            method: .get
        )
    }

    /// Builds `UserSecurityContext` from the first role entry in the response.
    ///
    /// Mobile sessions typically receive a single role UUID in `permissions`.
    /// Returns unrestricted admin-like defaults when the map is empty (matches legacy client behavior).
    public static func makeContext(from response: GlobalUserPermissionsResponse) -> UserSecurityContext {
        guard let permissions = response.firstRolePermissions else {
            return UserSecurityContext(
                isUnrestricted: true,
                prohibitAny: false,
                forceWatermark: false,
                defaultCameraAccess: .unspecified,
                mapsAccess: .unspecified,
                featureAccess: [],
                alertAccess: .forbid,
                bookmarkAccess: .unspecified
            )
        }
        return UserSecurityContext(globalPermissions: permissions)
    }
}
