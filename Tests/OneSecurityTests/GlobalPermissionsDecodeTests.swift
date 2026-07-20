import Foundation
import Testing
@testable import OneSecurity

@Suite("Global permissions decode")
struct GlobalPermissionsDecodeTests {
    @Test("admin is unrestricted")
    func admin() throws {
        let response = try FixtureLoader.decodePermissions(resource: "next_security_permissions_admin")
        let user = response.context
        #expect(user.isUnrestricted)
    }

    @Test("live only default camera access")
    func liveOnly() throws {
        let response = try FixtureLoader.decodePermissions(resource: "next_security_permissions_live_only")
        let user = response.context
        #expect(!user.isUnrestricted)
        #expect(user.defaultCameraAccess == .monitoring)
    }

    @Test("no cameras forbid access")
    func noCameras() throws {
        let response = try FixtureLoader.decodePermissions(resource: "next_security_permissions_no_cameras")
        let user = response.context
        #expect(!user.isUnrestricted)
        #expect(user.defaultCameraAccess == .forbid)
    }

    @Test("monitoring on protection default")
    func liveInArmed() throws {
        let response = try FixtureLoader.decodePermissions(resource: "next_security_permissions_live_in_armed")
        let user = response.context
        #expect(user.defaultCameraAccess == .monitoringOnProtection)
        #expect(!user.canViewLayouts)
    }

    @Test("force watermark from restrictions")
    func watermark() throws {
        let response = try FixtureLoader.decodePermissions(resource: "next_security_permissions_4_7")
        let user = response.context
        #expect(user.forceWatermark)
        #expect(user.defaultCameraAccess == .full)
    }

    @Test("layouts feature access")
    func layouts() throws {
        let response = try FixtureLoader.decodePermissions(resource: "next_security_permissions_layouts")
        let user = response.context
        #expect(user.canViewLayouts)
    }

    @Test("4_7 bookmark create-protect-edit-delete allows bookmarks")
    func bookmarksCreateAccess() throws {
        let response = try FixtureLoader.decodePermissions(resource: "next_security_permissions_4_7")
        let user = response.context
        #expect(user.canViewBookmarks)
    }

    @Test("user1 forbids bookmarks and maps")
    func user1BookmarksAndMaps() throws {
        let response = try FixtureLoader.decodePermissions(resource: "next_security_permissions_user1")
        let user = response.context
        #expect(!user.canViewBookmarks)
        #expect(!user.canViewMaps)
    }

    @Test("admin unrestricted sees maps journal bookmarks")
    func adminCapabilities() throws {
        let response = try FixtureLoader.decodePermissions(resource: "next_security_permissions_admin")
        let user = response.context
        #expect(user.canViewMaps)
        #expect(user.canViewSystemJournal)
        #expect(user.canViewBookmarks)
    }
}
