import Foundation

/// Per-camera access from `Camera.cameraAccess` (`GET /v1/domain/cameras`).
///
/// Server-computed effective access (object + group merged server-side).
/// Client fallback: if `.unspecified` → `UserSecurityContext.defaultCameraAccess` from global permissions.
public enum CameraAccess: String, Codable, Hashable, Sendable {
    /// Inherit from global `default_camera_access` when object access is not set.
    case unspecified = "CAMERA_ACCESS_UNSPECIFIED"
    /// No access to the camera screen or streams.
    case forbid = "CAMERA_ACCESS_FORBID"
    /// Archive only; live monitoring is forbidden by proto.
    case onlyArchive = "CAMERA_ACCESS_ONLY_ARCHIVE"
    /// Live only while the camera is on protection (`Camera.armed == true`).
    case monitoringOnProtection = "CAMERA_ACCESS_MONITORING_ON_PROTECTION"
    /// Live monitoring; archive is forbidden.
    case monitoring = "CAMERA_ACCESS_MONITORING"
    /// Archive and live (archive access includes monitoring in proto).
    case archive = "CAMERA_ACCESS_ARCHIVE"
    /// Archive, live, and archive management operations.
    case monitoringArchiveManage = "CAMERA_ACCESS_MONITORING_ARCHIVE_MANAGE"
    /// Full access to all camera surfaces.
    case full = "CAMERA_ACCESS_FULL"
}

extension CameraAccess {
    /// Whether the camera screen may be opened (anything except explicit forbid).
    public var canOpen: Bool {
        self != .forbid
    }

    /// Whether live is allowed **before** armed-state and unrestricted checks.
    ///
    /// Returns `false` for `.forbid` and `.onlyArchive`.
    /// `.monitoringOnProtection` returns `true` here; armed gating happens in `CameraPolicyEvaluator`.
    public var canSeeLive: Bool {
        !canNotSeeLive
    }

    /// Whether archive is allowed **before** `hasArchives` and unrestricted checks.
    public var canSeeArchive: Bool {
        !canNotSeeArchive
    }

    /// Live forbidden at the access level (proto semantics).
    public var canNotSeeLive: Bool {
        [.forbid, .onlyArchive].contains(self)
    }

    /// Archive forbidden at the access level (proto semantics).
    public var canNotSeeArchive: Bool {
        [.forbid, .monitoring, .monitoringOnProtection].contains(self)
    }
}
