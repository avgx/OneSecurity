import Foundation
import Testing
@testable import OneSecurity

@Suite("Map policy evaluator")
struct MapPolicyEvaluatorTests {
    private let viewScaleUser = UserSecurityContext(
        isUnrestricted: false,
        prohibitAny: false,
        forceWatermark: false,
        defaultCameraAccess: .monitoring,
        mapsAccess: .viewScale,
        featureAccess: [],
        alertAccess: .forbid,
        bookmarkAccess: .no
    )

    @Test("view scale allows pan and zoom")
    func viewScale() {
        let policy = MapPolicyEvaluator.evaluate(
            user: viewScaleUser,
            objectAccess: .unspecified
        )
        #expect(policy.canOpen)
        #expect(policy.canView)
        #expect(policy.canScale)
        #expect(!policy.canEdit)
    }

    @Test("view only blocks scale")
    func viewOnly() {
        let user = UserSecurityContext(
            isUnrestricted: false,
            prohibitAny: false,
            forceWatermark: false,
            defaultCameraAccess: .monitoring,
            mapsAccess: .viewOnly,
            featureAccess: [],
            alertAccess: .forbid,
            bookmarkAccess: .no
        )
        let policy = MapPolicyEvaluator.evaluate(
            user: user,
            objectAccess: .unspecified
        )
        #expect(policy.canView)
        #expect(!policy.canScale)
    }
}

@Suite("MapAccess semantics")
struct MapAccessCapabilitiesTests {
    @Test("capability matrix")
    func capabilities() {
        #expect(MapAccess.forbid.canOpen == false)
        #expect(MapAccess.viewOnly.canView)
        #expect(!MapAccess.viewOnly.canScale)
        #expect(MapAccess.viewScale.canScale)
        #expect(!MapAccess.viewScale.canEdit)
        #expect(MapAccess.full.canEdit)
    }
}
