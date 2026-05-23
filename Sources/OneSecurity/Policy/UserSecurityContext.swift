import Foundation

/// Session-wide security context from `GET /v1/security/permissions/global/user`.
///
/// Built via `SecurityApi.makeContext(from:)`. Per-camera decisions combine this context
/// with server-computed `Camera.cameraAccess` in `Camera.viewPolicy(for:)`.
public struct UserSecurityContext: Equatable, Sendable {
    /// Superuser role (`unrestricted_access == .yes`); bypasses access restrictions for camera surfaces.
    public let isUnrestricted: Bool
    /// Any GDPR personal-data flag is set on the role.
    public let prohibitAny: Bool
    /// `restrictions.force_username_watermarking` on the role.
    public let forceWatermark: Bool
    /// Fallback when per-camera access is `.unspecified`.
    public let defaultCameraAccess: CameraAccess
    private let featureAccess: [FeatureAccess]
    private let alertAccess: AlertAccess

    public init(
        isUnrestricted: Bool,
        prohibitAny: Bool,
        forceWatermark: Bool,
        defaultCameraAccess: CameraAccess,
        featureAccess: [FeatureAccess],
        alertAccess: AlertAccess
    ) {
        self.isUnrestricted = isUnrestricted
        self.prohibitAny = prohibitAny
        self.forceWatermark = forceWatermark
        self.defaultCameraAccess = defaultCameraAccess
        self.featureAccess = featureAccess
        self.alertAccess = alertAccess
    }

    /// Creates context from one decoded role permissions item.
    public init(globalPermissions: GlobalPermissions) {
        isUnrestricted = globalPermissions.unrestrictedAccess == .yes
        prohibitAny = globalPermissions.restrictions?.personalData.prohibitsAnyProcessing ?? false
        forceWatermark = globalPermissions.restrictions?.forceUsernameWatermarking ?? false
        defaultCameraAccess = globalPermissions.defaultCameraAccess
        featureAccess = globalPermissions.featureAccess
        alertAccess = globalPermissions.alertAccess
    }

    /// Layouts tab visibility (`FEATURE_ACCESS_LAYOUTS_TAB`).
    public var canViewLayouts: Bool {
        guard !isUnrestricted else { return true }
        return featureAccess.contains(.layoutsTab)
    }

    /// Group panel visibility (`FEATURE_ACCESS_GROUP_PANEL`).
    public var canViewGroups: Bool {
        guard !isUnrestricted else { return true }
        return featureAccess.contains(.groupPanel)
    }

    /// Alerts list visibility (view-only or full alert access).
    public var canViewAlerts: Bool {
        guard !isUnrestricted else { return true }
        return alertAccess == .viewOnly || alertAccess == .full
    }

    /// Alert review / acknowledge operations.
    public var canReviewAlerts: Bool {
        guard !isUnrestricted else { return true }
        return alertAccess == .full
    }
}
