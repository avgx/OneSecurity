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
    /// Global maps tab access from role permissions.
    public let mapsAccess: MapAccess
    private let featureAccess: [FeatureAccess]
    private let alertAccess: AlertAccess
    private let bookmarkAccess: BookmarkAccess

    public init(
        isUnrestricted: Bool,
        prohibitAny: Bool,
        forceWatermark: Bool,
        defaultCameraAccess: CameraAccess,
        mapsAccess: MapAccess,
        featureAccess: [FeatureAccess],
        alertAccess: AlertAccess,
        bookmarkAccess: BookmarkAccess
    ) {
        self.isUnrestricted = isUnrestricted
        self.prohibitAny = prohibitAny
        self.forceWatermark = forceWatermark
        self.defaultCameraAccess = defaultCameraAccess
        self.mapsAccess = mapsAccess
        self.featureAccess = featureAccess
        self.alertAccess = alertAccess
        self.bookmarkAccess = bookmarkAccess
    }

    /// Creates context from one decoded role permissions item.
    public init(globalPermissions: GlobalPermissions) {
        isUnrestricted = globalPermissions.unrestrictedAccess == .yes
        prohibitAny = globalPermissions.restrictions?.personalData?.prohibitsAnyProcessing ?? false
        forceWatermark = globalPermissions.restrictions?.forceUsernameWatermarking ?? false
        defaultCameraAccess = globalPermissions.defaultCameraAccess
        mapsAccess = globalPermissions.mapsAccess
        featureAccess = globalPermissions.featureAccess
        alertAccess = globalPermissions.alertAccess
        bookmarkAccess = globalPermissions.bookmarkAccess
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

    /// System journal / audit visibility (`FEATURE_ACCESS_SYSTEM_JOURNAL`).
    public var canViewSystemJournal: Bool {
        guard !isUnrestricted else { return true }
        return featureAccess.contains(.systemJournal)
    }

    /// Maps browser mode visibility (`maps_access` view levels).
    public var canViewMaps: Bool {
        guard !isUnrestricted else { return true }
        return mapsAccess.canView
    }

    /// Bookmarks journal visibility (`bookmark_access` create and above).
    public var canViewBookmarks: Bool {
        guard !isUnrestricted else { return true }
        switch bookmarkAccess {
        case .create, .createProtect, .createProtectEditDelete:
            return true
        case .no, .unspecified:
            return false
        }
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
