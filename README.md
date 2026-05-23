# OneSecurity

Swift package for Native BL **security** types (`bl/security/*.proto`), global permissions decode, and **camera viewing policy**.

**Platforms:** iOS 15+, macOS 13+, tvOS 17+, visionOS 1+  
**Swift tools:** 6.1+

## Dependencies

| Package | Role |
|---------|------|
| [RequestResponse](https://github.com/avgx/RequestResponse) | `SecurityApi.globalUserPermissions()` → `Request<GlobalUserPermissionsResponse>` |

## Permission model

Proto defines three server-side tiers (object → group → global). **The client trusts the server:**

| Source | Field | Client use |
|--------|-------|------------|
| `GET /v1/domain/cameras` | `Camera.cameraAccess` | Server-computed effective access |
| `GET /v1/security/permissions/global/user` | `default_camera_access` | Fallback when `cameraAccess == .unspecified` |

Group permissions (`GET /v1/security/permissions/groups`) are **not** merged client-side.

## Policy API

```swift
import OneSecurity
import OneDomain
import Get

let response = try await client.send(SecurityApi.globalUserPermissions(), with: baseURL)
let user = SecurityApi.makeContext(from: response.value)

let camera: Camera = ... // from DomainApi.cameras
let policy = camera.viewPolicy(for: user)

// policy.canOpen / canViewLive / canViewArchive
// policy.watermark / policy.masking
// policy.denialReason
```

Decision rules are documented in `///` on `CameraPolicyEvaluator.evaluate` (Xcode Quick Help).

### Outcomes (summary)

| Effective access | canOpen | canViewLive | canViewArchive |
|------------------|---------|-------------|----------------|
| `.forbid` | no | no | no |
| `.onlyArchive` | yes | no | yes* |
| `.monitoring` | yes | yes | no |
| `.monitoringOnProtection` | yes | yes if `armed`** | no |
| `.full` / unrestricted | yes | yes | yes* |

\* Requires archive bindings on camera.  
\** `Camera.armed == true`.

## Module layout

```
Sources/OneSecurity/
├── API/           SecurityApi
├── Access/        CameraAccess, FeatureAccess, …
├── Global/        GlobalPermissions, GlobalUserPermissionsResponse
└── Policy/        UserSecurityContext, CameraViewPolicy, CameraPolicyEvaluator
```

## Tests

```bash
swift test
```

Fixtures from VmsClientApp `next_security_permissions_*.json` under `Tests/OneSecurityTests/Resources/`.

## Related

- **[OneDomain](https://github.com/avgx/OneDomain)** — `Camera` model + `extension Camera { viewPolicy(for:) }`
- **Get** — HTTP client for `SecurityApi` requests
