import Foundation

/// Username overlay requirement on video surfaces.
public enum WatermarkPolicy: Equatable, Sendable {
    /// No server-mandated watermark.
    case none
    /// `restrictions.force_username_watermarking == true` on the user role.
    case usernameOverlay
}
