import Foundation

/// One role entry from `GlobalPermissions.proto` / `GET /v1/security/permissions/global/user`.
public struct GlobalPermissions: Codable, Equatable, Sendable {
    public let unrestrictedAccess: UnrestrictedAccess
    public let mapsAccess: MapAccess
    public let featureAccess: [FeatureAccess]
    public let restrictions: Restrictions?
    public let alertAccess: AlertAccess
    public let bookmarkAccess: BookmarkAccess
    public let userRightsSetupAccess: UserRightSetupAccess?
    /// Fallback when per-camera `camera_access` is `.unspecified`.
    public let defaultCameraAccess: CameraAccess
    public let defaultMicrophoneAccess: MicrophoneAccess
    public let defaultTelemetryPriority: TelemetryPriority?
    public let defaultArchiveAccess: ArchiveAccess
    public let defaultAcfaAccess: AcfaAccess?
    public let defaultVideowallAccess: VideowallAccess?
    public let archiveViewRestrictions: ArchiveViewRestrictions?
    public let defaultMacrosAccess: MacrosAccess?

    enum CodingKeys: String, CodingKey {
        case unrestrictedAccess = "unrestricted_access"
        case mapsAccess = "maps_access"
        case featureAccess = "feature_access"
        case restrictions
        case alertAccess = "alert_access"
        case bookmarkAccess = "bookmark_access"
        case userRightsSetupAccess = "user_rights_setup_access"
        case defaultCameraAccess = "default_camera_access"
        case defaultMicrophoneAccess = "default_microphone_access"
        case defaultTelemetryPriority = "default_telemetry_priority"
        case defaultArchiveAccess = "default_archive_access"
        case defaultAcfaAccess = "default_acfa_access"
        case defaultVideowallAccess = "default_videowall_access"
        case archiveViewRestrictions = "archive_view_restrictions"
        case defaultMacrosAccess = "default_macros_access"
    }
}
