# AGENTS.md — BitBake Recipes

## BitBake Recipes (.bb and .bbappend)

**File structure:**

```bitbake
SUMMARY = "Brief description"
DESCRIPTION = "Detailed description"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://example.service \
    file://example.sh \
"

S = "${WORKDIR}"

inherit systemd

DEPENDS = "dep1 dep2"
RDEPENDS:${PN} = "runtime-dep1"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/example.sh ${D}${bindir}
}
```

**Style rules:**

- Use 4 spaces for indentation (no tabs)
- Add space before and after assignments: `VAR = "value"`
- Use `:append` and `:remove` instead of `+=` and `-=` when possible
- Always quote variable expansions: `${VARIABLE}`
- Line continuation: backslash at end, indent continuation lines
- Use override syntax: `:append`, `:prepend`, `:remove`, `:machine-name`

### Configuration Files (.conf)

**Format:**

```
# Comment describing the setting
VARIABLE = "value"
VARIABLE:append = " additional-value"
VARIABLE:machine-override = "machine-specific-value"
```

**Conventions:**

- Group related settings together
- Add comments explaining non-obvious configurations
- Use override syntax for machine/distro specific values

### BBClass Files (.bbclass)

**Structure:**

```
# Class description and usage

# Variables that users should set
VARIABLE_NAME ??= "default-value"

# Implementation
python do_custom_task() {
    # Python code
}

# Or shell implementation
do_custom_task() {
    # Shell code
}
```

## Recipe Style Guide

### Recipe Header Order

Follow this standard order in all recipes:

1. **Metadata**: `SUMMARY`, `DESCRIPTION`
2. **Licensing**: `LICENSE`, `LIC_FILES_CHKSUM`
3. **Dependencies**: `DEPENDS`, `RDEPENDS`, `RRECOMMENDS`
4. **Source**: `SRC_URI`, `SRCREV`
5. **Version**: `PV` (if needed)
6. **Directories**: `S`, `B`
7. **Inheritance**: `inherit` statements
8. **Configuration**: `PACKAGECONFIG`, `EXTRA_OECMAKE`, etc.
9. **Package variables**: `FILES`, `SYSTEMD_SERVICE`, etc.
10. **Functions**: `do_*` tasks

### Source URI Formatting

**Multi-line sources (preferred):**

```bitbake
SRC_URI = " \
    file://example.service \
    file://example.sh \
    file://0001-fix.patch \
"
```

**Git sources:**

```bitbake
# Standard git
SRC_URI = "git://github.com/org/repo.git;protocol=https;branch=main"
SRCREV = "abc123..."

# With submodules (use gitsm://)
SRC_URI = "gitsm://github.com/org/repo.git;protocol=https;branch=main"
```

### Override Syntax

**Always use new override syntax:**

```bitbake
# Correct
DEPENDS:append = " extra-dep"           # Space at START
EXTRA_VAR:prepend = "prefix "           # Space at END
PACKAGECONFIG:remove = "unwanted"

# Machine-specific
RDEPENDS:${PN}:append:verdin-imx8mp = " special-package"

# Class-specific
DEPENDS:append:class-target = " target-dep"

# WRONG (old syntax - do not use)
DEPENDS += "extra-dep"
VARIABLE_append = "value"
```

**Critical**: Add space at START for `:append`, at END for `:prepend`

### Class Inheritance Patterns

```bitbake
# Systemd services
inherit allarch systemd
SYSTEMD_SERVICE:${PN} = "example.service"
SYSTEMD_AUTO_ENABLE = "enable"

# CMake projects
inherit cmake pkgconfig
EXTRA_OECMAKE = " \
    -DBUILD_TESTS=OFF \
    -DCMAKE_BUILD_TYPE=Release \
"

# Rust/Cargo
inherit cargo
SRC_URI += "crate://crates.io/serde/1.0.193"

# User creation
inherit useradd
USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = "-r -s /bin/false -U username"
```

### Dependencies: DEPENDS vs RDEPENDS

```bitbake
# DEPENDS - Build-time only (compile/link)
DEPENDS = "cmake-native boost curl openssl"

# RDEPENDS - Runtime (installed on target)
RDEPENDS:${PN} = "bash systemd coreutils"

# RRECOMMENDS - Optional runtime
RRECOMMENDS:${PN} = "optional-package"

# Conditional dependencies
DEPENDS:append = " ${@bb.utils.contains('PACKAGECONFIG', 'feature', 'dep-if-on', '', d)}"
RDEPENDS:${PN}:remove = "${@bb.utils.contains('DISTRO_FEATURES', 'x11', '', 'x11-package', d)}"
```

### PACKAGECONFIG

```bitbake
# Default features
PACKAGECONFIG ??= "feature1 feature2"

# Feature definitions (no spaces after commas!)
PACKAGECONFIG[systemd] = "-DSYSTEMD=ON,-DSYSTEMD=OFF,systemd,systemd"
#                         ^cmake-on    ^cmake-off    ^build-dep ^runtime-dep

# Add/remove based on distro
PACKAGECONFIG:append = " ${@bb.utils.filter('DISTRO_FEATURES', 'systemd', d)}"
PACKAGECONFIG:remove = "unwanted-feature"
```

### Task Functions

**Shell tasks:**

```bitbake
do_install() {
    # Always use install command (not cp/mkdir/chmod)
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/script.sh ${D}${bindir}/

    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/config.conf ${D}${sysconfdir}/

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/example.service ${D}${systemd_system_unitdir}/
}
```

**Python tasks:**

```bitbake
python do_custom_task() {
    workdir = d.getVar('WORKDIR')
    version = d.getVar('PV')
    bb.note(f"Processing version {version}")
}

# Inline Python expressions
VARIABLE = "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'yes', 'no', d)}"
```

### File Installation Patterns

**Standard directory variables (always use these):**

- `${bindir}` → `/usr/bin`
- `${sbindir}` → `/usr/sbin`
- `${libdir}` → `/usr/lib`
- `${sysconfdir}` → `/etc`
- `${datadir}` → `/usr/share`
- `${systemd_system_unitdir}` → `/lib/systemd/system`
- `${base_libdir}` → `/lib`

**File permissions:**

- Executables: `0755`
- Config files: `0644`
- Secrets: `0600` or `0400`
- Systemd units: `0644`

### Common Pitfalls

**1. Missing spaces in append/prepend:**

```bitbake
# WRONG - will concatenate
DEPENDS:append = "package"

# CORRECT
DEPENDS:append = " package"
```

**2. Using old override syntax:**

```bitbake
# WRONG
DEPENDS_${PN} += "package"

# CORRECT
DEPENDS:${PN}:append = " package"
```

**3. Hardcoded paths:**

```bitbake
# WRONG
install -d ${D}/usr/bin

# CORRECT
install -d ${D}${bindir}
```

**4. Missing ${D} prefix:**

```bitbake
# WRONG - installs to build host!
install -d ${bindir}

# CORRECT - installs to staging
install -d ${D}${bindir}
```

**5. Using cp instead of install:**

```bitbake
# WRONG
mkdir -p ${D}${bindir}
cp script.sh ${D}${bindir}/
chmod 0755 ${D}${bindir}/script.sh

# CORRECT
install -d ${D}${bindir}
install -m 0755 script.sh ${D}${bindir}/
```

**6. Incorrect DEPENDS vs RDEPENDS:**

```bitbake
# WRONG - runtime tools in DEPENDS
DEPENDS = "bash coreutils"

# CORRECT
DEPENDS = "cmake-native"           # Build-time
RDEPENDS:${PN} = "bash coreutils"  # Runtime
```

**7. Missing :${PN} suffix:**

```bitbake
# WRONG
SYSTEMD_SERVICE = "example.service"

# CORRECT
SYSTEMD_SERVICE:${PN} = "example.service"
```

**8. Not quoting variable expansions in shell:**

```bitbake
do_install() {
    # WRONG
    install -d ${D}${bindir}

    # CORRECT
    install -d "${D}${bindir}"
}
```

### Recipe Template

```bitbake
SUMMARY = "Brief one-line description"
DESCRIPTION = "Detailed description if needed"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "build-dependency"

SRC_URI = " \
    file://example.service \
    file://example.sh \
"

S = "${WORKDIR}"

inherit systemd

SYSTEMD_SERVICE:${PN} = "example.service"
SYSTEMD_AUTO_ENABLE = "enable"

RDEPENDS:${PN} = "runtime-dependency"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/example.sh ${D}${bindir}/

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/example.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} = " \
    ${bindir}/example.sh \
    ${systemd_system_unitdir}/example.service \
"
```
