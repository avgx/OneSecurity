import Foundation

/// Map access merge and viewing policy evaluation.
public enum MapPolicyEvaluator {
    /// Resolves effective map access from object, global default, and unrestricted bypass.
    ///
    /// ## Rules
    /// 1. `isUnrestricted == true` → `.full`
    /// 2. `object == .unspecified` → `global`
    /// 3. otherwise → `object` (server-computed effective access)
    public static func effectiveAccess(
        object: MapAccess,
        default global: MapAccess,
        isUnrestricted: Bool
    ) -> MapAccess {
        if isUnrestricted {
            return .full
        }
        if object == .unspecified {
            return global
        }
        return object
    }

    /// Computes the effective viewing policy for one map and one user session.
    public static func evaluate(
        user: UserSecurityContext,
        objectAccess: MapAccess
    ) -> MapViewPolicy {
        let effective = effectiveAccess(
            object: objectAccess,
            default: user.mapsAccess,
            isUnrestricted: user.isUnrestricted
        )

        let canOpen = effective.canOpen
        let canView = canOpen && effective.canView
        let canScale = canOpen && effective.canScale
        let canEdit = canOpen && effective.canEdit

        let denialReason: DenialReason? = canOpen ? nil : .accessForbidden

        return MapViewPolicy(
            canOpen: canOpen,
            canView: canView,
            canScale: canScale,
            canEdit: canEdit,
            denialReason: denialReason
        )
    }
}
