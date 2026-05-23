import Foundation

/// Effective viewing decision for one camera and one user session.
public struct CameraViewPolicy: Equatable, Sendable {
    /// Whether the camera detail screen may be opened.
    public let canOpen: Bool
    /// Whether live video may be shown.
    public let canViewLive: Bool
    /// Whether archive video may be shown.
    public let canViewArchive: Bool
    /// Server-mandated username watermark on video surfaces.
    public let watermark: WatermarkPolicy
    /// Privacy masking strategy for video renderers.
    public let masking: MaskingPolicy
    /// Primary denial reason when a surface is blocked; `nil` when fully allowed for evaluated surfaces.
    public let denialReason: DenialReason?

    public init(
        canOpen: Bool,
        canViewLive: Bool,
        canViewArchive: Bool,
        watermark: WatermarkPolicy,
        masking: MaskingPolicy,
        denialReason: DenialReason?
    ) {
        self.canOpen = canOpen
        self.canViewLive = canViewLive
        self.canViewArchive = canViewArchive
        self.watermark = watermark
        self.masking = masking
        self.denialReason = denialReason
    }
}
