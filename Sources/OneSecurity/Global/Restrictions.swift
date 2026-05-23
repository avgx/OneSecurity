import Foundation

/// Role restrictions from global `restrictions`.
public struct Restrictions: Codable, Equatable, Sendable {
    /// GDPR flags; any `true` value contributes to `UserSecurityContext.prohibitAny`.
    public let personalData: PersonalData
    /// When `true`, video surfaces should show a username watermark overlay.
    public let forceUsernameWatermarking: Bool

    enum CodingKeys: String, CodingKey {
        case personalData = "personal_data"
        case forceUsernameWatermarking = "force_username_watermarking"
    }
}
