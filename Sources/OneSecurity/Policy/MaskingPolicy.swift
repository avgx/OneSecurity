import Foundation

/// Privacy masking strategy for video renderers.
public enum MaskingPolicy: Equatable, Sendable {
    /// No masking required.
    case none
    /// Server-configured static privacy masks (`Camera.privacyMask`); apply mask overlay, not pixelate.
    case privacyMasks
    /// GDPR active and camera has mask capability but no static masks configured; pixelate frames.
    case pixelate
    /// Live stream advertises a dynamic privacy mask under GDPR (stream-level mask messages).
    case dynamicMask
}
