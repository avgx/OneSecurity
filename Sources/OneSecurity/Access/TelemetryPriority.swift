import Foundation

public enum TelemetryPriority: String, Codable, Hashable, Sendable {
    case unspecified = "TELEMETRY_PRIORITY_UNSPECIFIED"
    case noAccess = "TELEMETRY_PRIORITY_NO_ACCESS"
    case lowest = "TELEMETRY_PRIORITY_LOWEST"
    case low = "TELEMETRY_PRIORITY_LOW"
    case normal = "TELEMETRY_PRIORITY_NORMAL"
    case high = "TELEMETRY_PRIORITY_HIGH"
    case highest = "TELEMETRY_PRIORITY_HIGHEST"
}
