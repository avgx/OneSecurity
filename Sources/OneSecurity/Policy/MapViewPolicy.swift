import Foundation

/// Effective viewing decision for one map and one user session.
public struct MapViewPolicy: Equatable, Sendable {
    /// Whether the map detail screen may be opened.
    public let canOpen: Bool
    /// Whether the map content may be displayed.
    public let canView: Bool
    /// Whether zoom and pan are allowed.
    public let canScale: Bool
    /// Whether map editing is allowed.
    public let canEdit: Bool
    /// Primary denial reason when a surface is blocked; `nil` when fully allowed for evaluated surfaces.
    public let denialReason: DenialReason?

    public init(
        canOpen: Bool,
        canView: Bool,
        canScale: Bool,
        canEdit: Bool,
        denialReason: DenialReason?
    ) {
        self.canOpen = canOpen
        self.canView = canView
        self.canScale = canScale
        self.canEdit = canEdit
        self.denialReason = denialReason
    }
}
