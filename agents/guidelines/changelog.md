## Version Format

All versions follow this format:

```
major.minor.patch~revision-prerelease+build
```

### Version Components

| Field           | Required | Symbol        | Description                              | Example                     |
| --------------- | -------- | ------------- | ---------------------------------------- | --------------------------- |
| **Major**       | Yes      | `X`           | Incompatible API changes                 | `1`                         |
| **Minor**       | Yes      | `Y`           | New features with backward compatibility | `2`                         |
| **Patch**       | Yes      | `Z`           | Bug fixes only                           | `3`                         |
| **Revision**    | No       | `~N`          | Downstream package changes               | `~4`                        |
| **Pre-release** | No       | `-identifier` | Development/testing versions             | `-alpha1`, `-beta2`, `-rc1` |
| **Build**       | No       | `+identifier` | Build metadata                           | `+git.abc123`, `+build.001` |

### Complete Example

```
1.2.3~4-beta5.dev+git.abc123.build001
```

Parsed as:

- Major: `1`
- Minor: `2`
- Patch: `3`
- Revision: `4`
- Pre-release: `beta5.dev`
- Build: `git.abc123.build001`

## Git Tagging Rules

### Standard Tags

- Use format: `v{major}.{minor}.{patch}`
- Examples: `v1.0.0`, `v2.1.5`, `v0.3.2`

### Tags with Revision

Since `~` is not allowed in Git tags, replace `~` with `.`:

- Version `1.2.3~4` becomes tag `v1.2.3.4`
- The agent should automatically convert between formats

### Pre-release Tags

- Development: `v1.2.3-dev`, `v1.2.3-alpha1`
- Beta: `v1.2.3-beta1`, `v1.2.3-beta2`
- Release Candidate: `v1.2.3-rc1`, `v1.2.3-rc2`

### Build Tags

- Include build metadata: `v1.2.3+build001`
- Git commit info: `v1.2.3+git.abc123`

## Version Precedence Rules

When comparing versions, evaluate fields left to right:

### Precedence Examples

```
2.0.0 > 1.9.9     (major version takes precedence)
1.2.0 > 1.1.9     (minor version comparison)
1.2.4 > 1.2.3     (patch version comparison)
1.2.3~2 > 1.2.3~1 (revision comparison)
1.2.3 > 1.2.3-alpha1  (release > pre-release)
1.2.3-beta1 > 1.2.3-alpha1  (alphabetical for pre-release)
```

### Special Rules

1. **Revision default**: `1.2.3~0` equals `1.2.3`
2. **Pre-release precedence**: Any pre-release version is lower than the
   corresponding release
3. **Build metadata**: Ignored in version comparison
4. **Numeric vs alphabetic**: Non-numeric identifiers have higher precedence
   than numeric ones

## Instructions for Git Tagging

### Automatic Tagging Workflow

1. **Analyze commits** since last tag to determine version increment:
    - **Major increment** (`X.0.0`): Breaking changes, API incompatibilities
    - **Minor increment** (`X.Y.0`): New features, backward compatible
    - **Patch increment** (`X.Y.Z`): Bug fixes only
    - **Revision increment** (`X.Y.Z~N`): Downstream/packaging changes only

2. **Detect commit types** using conventional commits:

    ```
    feat: → minor version bump
    fix: → patch version bump
    BREAKING CHANGE: → major version bump
    build/ci/docs: → revision bump (if no other changes)
    ```

3. **Pre-release handling**:
    - Development branches: Add `-dev` suffix
    - Feature branches: Use `feature/{branch-name}` pattern
    - Bugfix branches: Use `bugfix/{branch-name}` pattern
    - Release candidates: Use `-rc{N}` pattern

4. **Tag creation**:

    ```bash
    # Standard release
    git tag -a v1.2.3 -m "Release version 1.2.3"

    # Pre-release
    git tag -a v1.2.3-rc1 -m "Release candidate 1.2.3-rc1"

    # With build info
    git tag -a v1.2.3+build001 -m "Release 1.2.3 build 001"
    ```

## Agent Instructions for Package Generation

### Application Packages

1. **Version extraction** from git tags:

    ```bash
    # Get latest tag
    VERSION=$(git describe --tags --abbrev=0)
    # Convert git tag to version (handle ~ replacement)
    VERSION=${VERSION#v}  # Remove 'v' prefix
    VERSION=${VERSION//.~/~}  # Convert back dots to tilde for revisions
    ```

2. **Package naming conventions**:
    - Application: `{app-name}_{version}_{arch}.{format}`
    - Example: `myapp_1.2.3~4_amd64.deb`
    - Yocto recipe: `{app-name}_${PV}.bb` where `PV = "1.2.3"`

3. **Version variables for build systems**:
    ```makefile
    # Makefile variables
    VERSION_MAJOR := 1
    VERSION_MINOR := 2
    VERSION_PATCH := 3
    VERSION_REVISION := 4
    VERSION_FULL := 1.2.3~4
    ```

### Yocto Integration

1. **Recipe versioning**:

    ```bitbake
    # In recipe file
    PV = "1.2.3"
    PR = "r4"  # Maps to revision field

    # For pre-releases
    PV = "1.2.3+gitAUTOINC+abc1234"
    ```

2. **Package versioning**:

    ```bitbake
    # Package version follows format
    PKGV = "${PV}"
    PKGR = "${PR}"
    ```

3. **Git integration**:
    ```bitbake
    # Use git tags for version
    SRCREV = "${AUTOREV}"
    PV = "1.2.3+git${SRCPV}"
    ```

## Version Range Specifications

For dependency management, use these operators:

### Comparison Operators

- `>=1.2.3`: Greater than or equal
- `>1.2.3`: Greater than
- `==1.2.3`: Exactly equal
- `<1.2.3`: Less than
- `<=1.2.3`: Less than or equal
- `!=1.2.3`: Not equal

### Wildcard Specifications

- `1.2.*`: Any patch version in 1.2.x series
- `1.*`: Any version in 1.x.x series
- `*`: Any version

### Compatible Release

- `~=1.2.3`: Compatible with 1.2.3 (allows 1.2.4, 1.2.5, but not 1.3.0)
- `~1.2.3`: Allows patch-level changes (equivalent to >=1.2.3,<1.3.0)
- `^1.2.3`: Allows minor-level changes (equivalent to >=1.2.3,<2.0.0)

## Automation Examples

### Git Hook for Auto-tagging

```bash
#!/bin/bash
# post-commit hook
if [[ $(git log -1 --pretty=%B) =~ ^(feat|fix|BREAKING).*$ ]]; then
    # Determine version increment based on commit message
    # Create appropriate tag
    # Push to remote
fi
```

### CI/CD Pipeline Integration

```yaml
# Example GitHub Actions/GitLab CI
version_increment:
    script:
        - current_version=$(git describe --tags --abbrev=0 2>/dev/null || echo
          "v0.0.0")
        - new_version=$(calculate_next_version $current_version)
        - git tag -a $new_version -m "Auto-generated release $new_version"
        - git push origin $new_version
```

### Package Build Script

```bash
#!/bin/bash
# Extract version from git
VERSION=$(git describe --tags --exact-match HEAD 2>/dev/null || git describe --tags --abbrev=7)
VERSION=${VERSION#v}  # Remove v prefix

# Build packages with version
make package VERSION=$VERSION
dpkg-buildpackage -b --version=$VERSION
```

## Validation Rules

### Tag Validation

- Must follow format:
  `v?(\d+)\.(\d+)\.(\d+)(\.(\d+))?(-[a-zA-Z0-9\.-]+)?(\+[a-zA-Z0-9\.-]+)?`
- Major, minor, patch must be non-negative integers
- Pre-release and build identifiers must not be empty
- No leading zeros in numeric components (except standalone `0`)

### Version Ordering

- Agents must correctly sort versions according to precedence rules
- Pre-release versions must be handled appropriately
- Build metadata must be ignored in comparisons

### Error Handling

- Invalid version formats should be rejected
- Conflicting tags should be detected and reported
- Missing version information should trigger appropriate defaults

## Best Practices

1. **Semantic meaning**: Ensure version increments reflect actual changes
2. **Consistency**: Use the same versioning scheme across all components
3. **Automation**: Leverage git hooks and CI/CD for version management
4. **Documentation**: Keep changelog updated with each version
5. **Testing**: Validate version parsing and comparison logic
6. **Rollback**: Maintain ability to revert problematic versions

This specification enables language model agents to consistently handle
versioning across git repositories, application packaging, and Yocto-based image
generation while maintaining semantic meaning and compatibility requirements.

## Changelog Generation

Follow [Keep a Changelog](https://keepachangelog.com/) format and principles:

- **Get commit history**: `git log --format="%h %s%n%b" -N` (where N is number
  of commits)
- **Structure**: Use standard Keep a Changelog format:
    - Header with project name and adherence to Keep a Changelog/Semantic
      Versioning
    - `## [Unreleased]` section at top for upcoming changes
    - Version sections in reverse chronological order: `## [X.Y.Z] - YYYY-MM-DD`
    - Bottom section with version comparison links
- **Change categories** (use as subsections under each version):
    - `### Added` - for new features
    - `### Changed` - for changes in existing functionality
    - `### Deprecated` - for soon-to-be removed features
    - `### Removed` - for now removed features
    - `### Fixed` - for any bug fixes
    - `### Security` - in case of vulnerabilities
- **Entry format**:
    - One line per change, starting with dash and space
    - Focus on what changed for users, not implementation details
    - Include ticket numbers (NGM-XXXX format) when applicable
    - Avoid commit hashes in entries (changelogs are for humans, not machines)
- **Date format**: Use ISO 8601 format (YYYY-MM-DD)
- **Guiding principles**:
    - Write for humans, not machines
    - Group same types of changes together
    - Latest version comes first
    - Make versions and sections linkable
    - Keep an Unreleased section for tracking upcoming changes
