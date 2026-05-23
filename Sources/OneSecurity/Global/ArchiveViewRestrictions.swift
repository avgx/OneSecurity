import Foundation

/// Archive depth restriction from global `archive_view_restrictions`.
public struct ArchiveViewRestrictions: Codable, Equatable, Sendable {
    public let depthHours: String

    enum CodingKeys: String, CodingKey {
        case depthHours = "depth_hours"
    }
}
