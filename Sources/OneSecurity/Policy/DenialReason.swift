import Foundation

/// Why a camera surface is unavailable. `nil` when the evaluated surface is allowed.
public enum DenialReason: Equatable, Sendable {
    /// Effective access is `.forbid` (explicit on camera or via global default).
    case accessForbidden
    /// Access is `.monitoringOnProtection` but `Camera.armed != true`.
    case notArmed
    /// Access allows archive but the camera has no archive bindings.
    case noArchives
}
