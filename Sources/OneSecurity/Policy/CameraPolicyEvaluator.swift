import Foundation

/// Camera access merge and viewing policy evaluation.
public enum CameraPolicyEvaluator {
    /// Resolves effective camera access from object, global default, and unrestricted bypass.
    ///
    /// ## Rules
    /// 1. `isUnrestricted == true` → `.full`
    /// 2. `object == .unspecified` → `global`
    /// 3. otherwise → `object` (server-computed effective access)
    public static func effectiveAccess(
        object: CameraAccess,
        default global: CameraAccess,
        isUnrestricted: Bool
    ) -> CameraAccess {
        if isUnrestricted {
            return .full
        }
        if object == .unspecified {
            return global
        }
        return object
    }

    /// Computes the effective viewing policy for one camera and one user session.
    ///
    /// ## Inputs
    /// - `user` — from `SecurityApi.makeContext` / global permissions API
    /// - `objectAccess` — from `Camera.cameraAccess` (server-computed effective access)
    /// - `isArmed` — from `Camera.armed`; required for `.monitoringOnProtection`
    /// - mask flags — static: non-empty `privacyMask`; dynamic: live stream capability
    /// - `hasArchives` — whether archive UI should be offered
    ///
    /// ## Algorithm
    /// 1. Merge access via `effectiveAccess`.
    /// 2. `canOpen = effective.canOpen`.
    /// 3. `canViewLive = effective.canSeeLive`, then if `.monitoringOnProtection` require `isArmed == true`.
    /// 4. `canViewArchive = effective.canSeeArchive && hasArchives`.
    /// 5. Watermark: `user.forceWatermark` → `.usernameOverlay`.
    /// 6. Masking (first match): static masks → `.privacyMasks`; else GDPR+mask capability → `.pixelate`;
    ///    else dynamic mask + GDPR → `.dynamicMask`.
    /// 7. `DenialReason` when a primary surface is denied.
    ///
    /// ## Examples
    /// - `.unspecified` + default `.monitoring` → live yes, archive no.
    /// - `.monitoringOnProtection`, `armed=false` → open yes, live no, reason `.notArmed`.
    /// - `prohibitAny` without mask capability on camera → masking `.none`.
    public static func evaluate(
        user: UserSecurityContext,
        objectAccess: CameraAccess,
        isArmed: Bool?,
        hasStaticPrivacyMask: Bool,
        hasDynamicPrivacyMask: Bool,
        hasArchives: Bool
    ) -> CameraViewPolicy {
        let effective = effectiveAccess(
            object: objectAccess,
            default: user.defaultCameraAccess,
            isUnrestricted: user.isUnrestricted
        )

        let canOpen = effective.canOpen

        var canViewLive = effective.canSeeLive
        if effective == .monitoringOnProtection {
            canViewLive = isArmed == true
        }

        let archiveAllowedByAccess = effective.canSeeArchive
        let canViewArchive = archiveAllowedByAccess && hasArchives

        let watermark: WatermarkPolicy = user.forceWatermark ? .usernameOverlay : .none
        let masking = maskingPolicy(
            user: user,
            hasStaticPrivacyMask: hasStaticPrivacyMask,
            hasDynamicPrivacyMask: hasDynamicPrivacyMask
        )

        let denialReason = denialReason(
            canOpen: canOpen,
            canViewLive: canViewLive,
            effective: effective,
            archiveAllowedByAccess: archiveAllowedByAccess,
            hasArchives: hasArchives
        )

        return CameraViewPolicy(
            canOpen: canOpen,
            canViewLive: canOpen && canViewLive,
            canViewArchive: canOpen && canViewArchive,
            watermark: watermark,
            masking: masking,
            denialReason: denialReason
        )
    }

    private static func maskingPolicy(
        user: UserSecurityContext,
        hasStaticPrivacyMask: Bool,
        hasDynamicPrivacyMask: Bool
    ) -> MaskingPolicy {
        if hasStaticPrivacyMask {
            return .privacyMasks
        }

        let maskCapability = hasStaticPrivacyMask || hasDynamicPrivacyMask
        let gdprActive = user.prohibitAny && maskCapability

        if gdprActive {
            return .pixelate
        }

        if hasDynamicPrivacyMask && user.prohibitAny {
            return .dynamicMask
        }

        return .none
    }

    private static func denialReason(
        canOpen: Bool,
        canViewLive: Bool,
        effective: CameraAccess,
        archiveAllowedByAccess: Bool,
        hasArchives: Bool
    ) -> DenialReason? {
        if !canOpen {
            return .accessForbidden
        }
        if effective == .monitoringOnProtection && !canViewLive {
            return .notArmed
        }
        if archiveAllowedByAccess && !hasArchives {
            return .noArchives
        }
        return nil
    }
}
