import Foundation
import Testing
@testable import OneSecurity

@Suite("Camera policy evaluator")
struct CameraPolicyEvaluatorTests {
    private let monitoringUser = UserSecurityContext(
        isUnrestricted: false,
        prohibitAny: false,
        forceWatermark: false,
        defaultCameraAccess: .monitoring,
        featureAccess: [],
        alertAccess: .forbid
    )

    private let fullUser = UserSecurityContext(
        isUnrestricted: false,
        prohibitAny: false,
        forceWatermark: false,
        defaultCameraAccess: .full,
        featureAccess: [],
        alertAccess: .forbid
    )

    @Test("unspecified object inherits global default")
    func unspecifiedInheritsDefault() {
        let policy = CameraPolicyEvaluator.evaluate(
            user: monitoringUser,
            objectAccess: .unspecified,
            isArmed: nil,
            hasStaticPrivacyMask: false,
            hasDynamicPrivacyMask: false,
            hasArchives: true
        )
        #expect(policy.canOpen)
        #expect(policy.canViewLive)
        #expect(!policy.canViewArchive)
    }

    @Test("forbid blocks all surfaces")
    func forbid() {
        let policy = CameraPolicyEvaluator.evaluate(
            user: monitoringUser,
            objectAccess: .forbid,
            isArmed: true,
            hasStaticPrivacyMask: false,
            hasDynamicPrivacyMask: false,
            hasArchives: true
        )
        #expect(!policy.canOpen)
        #expect(!policy.canViewLive)
        #expect(!policy.canViewArchive)
        #expect(policy.denialReason == .accessForbidden)
    }

    @Test("monitoring on protection requires armed for live")
    func monitoringOnProtectionNotArmed() {
        let policy = CameraPolicyEvaluator.evaluate(
            user: fullUser,
            objectAccess: .monitoringOnProtection,
            isArmed: false,
            hasStaticPrivacyMask: false,
            hasDynamicPrivacyMask: false,
            hasArchives: true
        )
        #expect(policy.canOpen)
        #expect(!policy.canViewLive)
        #expect(policy.denialReason == .notArmed)
    }

    @Test("monitoring on protection allows live when armed")
    func monitoringOnProtectionArmed() {
        let policy = CameraPolicyEvaluator.evaluate(
            user: fullUser,
            objectAccess: .monitoringOnProtection,
            isArmed: true,
            hasStaticPrivacyMask: false,
            hasDynamicPrivacyMask: false,
            hasArchives: true
        )
        #expect(policy.canViewLive)
        #expect(policy.denialReason == nil)
    }

    @Test("archive requires bindings")
    func noArchivesDenial() {
        let policy = CameraPolicyEvaluator.evaluate(
            user: fullUser,
            objectAccess: .onlyArchive,
            isArmed: nil,
            hasStaticPrivacyMask: false,
            hasDynamicPrivacyMask: false,
            hasArchives: false
        )
        #expect(policy.canOpen)
        #expect(!policy.canViewLive)
        #expect(!policy.canViewArchive)
        #expect(policy.denialReason == .noArchives)
    }

    @Test("unrestricted bypasses access limits")
    func unrestricted() {
        let user = UserSecurityContext(
            isUnrestricted: true,
            prohibitAny: false,
            forceWatermark: false,
            defaultCameraAccess: .forbid,
            featureAccess: [],
            alertAccess: .forbid
        )
        let policy = CameraPolicyEvaluator.evaluate(
            user: user,
            objectAccess: .forbid,
            isArmed: false,
            hasStaticPrivacyMask: false,
            hasDynamicPrivacyMask: false,
            hasArchives: true
        )
        #expect(policy.canOpen)
        #expect(policy.canViewLive)
        #expect(policy.canViewArchive)
    }

    @Test("watermark from user context")
    func watermark() {
        let user = UserSecurityContext(
            isUnrestricted: false,
            prohibitAny: false,
            forceWatermark: true,
            defaultCameraAccess: .full,
            featureAccess: [],
            alertAccess: .forbid
        )
        let policy = CameraPolicyEvaluator.evaluate(
            user: user,
            objectAccess: .full,
            isArmed: true,
            hasStaticPrivacyMask: false,
            hasDynamicPrivacyMask: false,
            hasArchives: true
        )
        #expect(policy.watermark == .usernameOverlay)
    }

    @Test("static privacy masks without GDPR")
    func staticMasksWithoutGDPR() {
        let policy = CameraPolicyEvaluator.evaluate(
            user: monitoringUser,
            objectAccess: .full,
            isArmed: true,
            hasStaticPrivacyMask: true,
            hasDynamicPrivacyMask: false,
            hasArchives: true
        )
        #expect(policy.masking == .privacyMasks)
    }

    @Test("GDPR pixelate when dynamic mask capability")
    func gdprPixelate() {
        let user = UserSecurityContext(
            isUnrestricted: false,
            prohibitAny: true,
            forceWatermark: false,
            defaultCameraAccess: .full,
            featureAccess: [],
            alertAccess: .forbid
        )
        let policy = CameraPolicyEvaluator.evaluate(
            user: user,
            objectAccess: .full,
            isArmed: true,
            hasStaticPrivacyMask: false,
            hasDynamicPrivacyMask: true,
            hasArchives: true
        )
        #expect(policy.masking == .pixelate)
    }

    @Test("GDPR alone does not mask without capability")
    func gdprWithoutMaskCapability() {
        let user = UserSecurityContext(
            isUnrestricted: false,
            prohibitAny: true,
            forceWatermark: false,
            defaultCameraAccess: .full,
            featureAccess: [],
            alertAccess: .forbid
        )
        let policy = CameraPolicyEvaluator.evaluate(
            user: user,
            objectAccess: .full,
            isArmed: true,
            hasStaticPrivacyMask: false,
            hasDynamicPrivacyMask: false,
            hasArchives: true
        )
        #expect(policy.masking == .none)
    }
}

@Suite("CameraAccess semantics")
struct CameraAccessTests {
    @Test("monitoring live yes archive no")
    func monitoring() {
        #expect(CameraAccess.monitoring.canSeeLive)
        #expect(!CameraAccess.monitoring.canSeeArchive)
    }

    @Test("only archive")
    func onlyArchive() {
        #expect(!CameraAccess.onlyArchive.canSeeLive)
        #expect(CameraAccess.onlyArchive.canSeeArchive)
    }

    @Test("arm/disarm allowed only for full and monitoringArchiveManage")
    func canChangeArmState() {
        #expect(CameraAccess.full.canChangeArmState)
        #expect(CameraAccess.monitoringArchiveManage.canChangeArmState)
        #expect(!CameraAccess.monitoring.canChangeArmState)
        #expect(!CameraAccess.archive.canChangeArmState)
        #expect(!CameraAccess.monitoringOnProtection.canChangeArmState)
        #expect(!CameraAccess.onlyArchive.canChangeArmState)
        #expect(!CameraAccess.forbid.canChangeArmState)
        #expect(!CameraAccess.unspecified.canChangeArmState)
    }
}
