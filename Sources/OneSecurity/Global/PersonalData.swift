import Foundation

/// GDPR / personal-data restrictions from global `restrictions.personal_data`.
public struct PersonalData: Codable, Equatable, Sendable {
    public let prohibitFaceRecognition: Bool
    public let prohibitLicensePlateRecognition: Bool
    public let prohibitSimilaritySearch: Bool
    public let prohibitVehicleRecognition: Bool

    enum CodingKeys: String, CodingKey {
        case prohibitFaceRecognition = "prohibit_face_recognition"
        case prohibitLicensePlateRecognition = "prohibit_license_plate_recognition"
        case prohibitSimilaritySearch = "prohibit_similarity_search"
        case prohibitVehicleRecognition = "prohibit_vehicle_recognition"
    }
}

extension PersonalData {
    /// `true` when any GDPR personal-data flag is set on the role.
    public var prohibitsAnyProcessing: Bool {
        prohibitFaceRecognition
            || prohibitLicensePlateRecognition
            || prohibitSimilaritySearch
            || prohibitVehicleRecognition
    }
}
