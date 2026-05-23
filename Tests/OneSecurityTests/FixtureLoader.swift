import Foundation
import Testing
@testable import OneSecurity

enum FixtureLoader {
    static func data(resource: String, ext: String = "json") throws -> Data {
        guard let url = Bundle.module.url(forResource: resource, withExtension: ext) else {
            throw FixtureError.missing(resource: resource, ext: ext)
        }
        return try Data(contentsOf: url)
    }

    static func decodePermissions(resource: String) throws -> GlobalUserPermissionsResponse {
        try JSONDecoder().decode(GlobalUserPermissionsResponse.self, from: data(resource: resource))
    }
}

enum FixtureError: Error {
    case missing(resource: String, ext: String)
}

extension GlobalUserPermissionsResponse {
    var context: UserSecurityContext {
        SecurityApi.makeContext(from: self)
    }
}
