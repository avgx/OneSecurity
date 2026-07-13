import Foundation

extension MapAccess {
    /// Whether the map screen may be opened.
    public var canOpen: Bool {
        self != .forbid
    }

    /// Whether the map may be viewed.
    public var canView: Bool {
        switch self {
        case .viewOnly, .viewScale, .full:
            return true
        default:
            return false
        }
    }

    /// Whether zoom and pan are allowed.
    public var canScale: Bool {
        switch self {
        case .viewScale, .full:
            return true
        default:
            return false
        }
    }

    /// Whether map editing is allowed.
    public var canEdit: Bool {
        self == .full
    }
}
