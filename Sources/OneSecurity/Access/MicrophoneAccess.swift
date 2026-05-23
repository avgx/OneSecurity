import Foundation

/// Microphone access from domain models or global `default_microphone_access`.
public enum MicrophoneAccess: String, Codable, Hashable, Sendable {
    case unspecified = "MICROPHONE_ACCESS_UNSPECIFIED"
    case forbid = "MICROPHONE_ACCESS_FORBID"
    case monitoring = "MICROPHONE_ACCESS_MONITORING"
    case full = "MICROPHONE_ACCESS_FULL"
}
