# AGENTS.md — CMake Code Style Guide

Purpose: CMake coding standards and best practices for AI agents working with
CMake projects. Follow these guidelines for consistent, maintainable, and modern
CMake code.

## Core Principles

- **Use Modern CMake (3.15+)**: Prefer CMake 3.15 or newer for new projects
- **Think in Targets**: Every concept should be represented as a target with
  clear interfaces
- **Explicit over Implicit**: Use keywords everywhere (PUBLIC/PRIVATE/INTERFACE)
- **Treat CMake as Code**: Apply the same quality standards as other source code

## Version Requirements

### Minimum Version Declaration

```cmake
# Always specify a range for better policy management
cmake_minimum_required(VERSION 3.15...4.1)
```

### Version Selection Guidelines

- **3.15**: Minimum for most new projects (Ubuntu 20.04+)
- **3.18**: Good baseline with Python/CUDA support
- **3.20**: C++23 support, cmake_path command
- **3.24**: Package finder integration with FetchContent
- **Latest**: Always test with newest stable version

## Project Structure

### Canonical Directory Layout

```
project/
├── CMakeLists.txt              # Root CMake file
├── cmake/                      # CMake modules and helpers
│   ├── FindSomeLib.cmake
│   └── project-config.cmake.in
├── include/project/            # Public headers
├── src/                        # Implementation files
│   └── CMakeLists.txt
├── apps/                       # Executables
│   └── CMakeLists.txt
├── tests/                      # Test files
│   └── CMakeLists.txt
├── extern/                     # Git submodules only
└── build*/                     # Build directories (in .gitignore)
```

## Basic CMake Syntax

### Project Declaration

```cmake
project(MyProject
    VERSION 1.0.0
    DESCRIPTION "Project description"
    LANGUAGES CXX)
```

### Target Creation

```cmake
# Executables
add_executable(myapp main.cpp)

# Libraries - prefer specific type
add_library(mylib STATIC src1.cpp src2.cpp include/header.h)

# Interface libraries for header-only
add_library(headeronly INTERFACE)
```

### Target Properties (ALWAYS use keywords)

```cmake
target_include_directories(mylib PUBLIC include)
target_compile_features(mylib PUBLIC cxx_std_17)
target_link_libraries(myapp PRIVATE mylib)
target_compile_options(mylib PRIVATE -Wall)
```

## Modern CMake Antipatterns (AVOID)

- **AVOID** `link_directories()` - Use `target_link_libraries()` with full paths
- **AVOID** `include_directories()` - Use `target_include_directories()`
- **AVOID** `add_compile_options()` - Use `target_compile_options()`
- **AVOID** Global functions without keywords
- **AVOID** `file(GLOB *.cpp)` - List files explicitly (or use
  CONFIGURE_DEPENDS)
- **AVOID** Setting compiler flags manually - Use target properties
- **AVOID** Skipping PUBLIC/PRIVATE/INTERFACE keywords

## Variable and Cache Management

### Local Variables

```cmake
set(MY_VARIABLE "value")
set(MY_LIST "item1" "item2")  # Semicolon-separated internally
```

### Cache Variables

```cmake
set(BUILD_TESTS ON CACHE BOOL "Build test suite")
option(ENABLE_FEATURE "Enable optional feature" OFF)
```

### Properties

```cmake
# Set properties on targets
set_target_properties(mytarget PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO)
```

## C++ Standards

> [!NOTE]
>
> The following rules apply to the C language but may require adaptation.

### Preferred Method (CMake 3.8+)

```cmake
target_compile_features(mytarget PUBLIC cxx_std_17)
set_target_properties(mytarget PROPERTIES CXX_EXTENSIONS OFF)
```

### Compiler Features (CMake 3.1+)

```cmake
target_compile_features(mytarget PUBLIC
    cxx_nullptr
    cxx_range_for
    cxx_override)
```

## Generator Expressions

Use generator expressions for build-time conditionals:

```cmake
# Configuration-specific flags
target_compile_options(mytarget PRIVATE
    "$<$<CONFIG:Debug>:-g3>"
    "$<$<CONFIG:Release>:-O3>")

# Build vs install interface
target_include_directories(mytarget PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>)
```

## Dependency Management

### Modern Package Finding

```cmake
find_package(SomeLib REQUIRED)
target_link_libraries(mytarget PRIVATE SomeLib::SomeLib)
```

> [!NOTE] Legacy pkg-config dependencies
>
> - When integrating libraries via pkg-config in CMake, agents MUST use the
>   `pkg_check_modules(... IMPORTED_TARGET)` form instead of manually handling
>   compiler or linker flags.
> - Link to the generated imported targets (e.g., `PkgConfig::<MODULE_NAME>`)
>   rather than manually inserting `${<MODULE>_CFLAGS_OTHER}` or
>   `${<MODULE>_LDFLAGS_OTHER}` variables.
> - This ensures that all compile and link flags are automatically preserved,
>   correctly propagated transitively, and compliant with modern CMake
>   practices.

### FetchContent (CMake 3.11+)

```cmake
include(FetchContent)
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.14.0)
FetchContent_MakeAvailable(googletest)
```

## Functions and Macros

### Prefer Functions Over Macros

```cmake
function(my_function TARGET_NAME)
    cmake_parse_arguments(PARSE_ARGV 1 ARG
        "OPTIONAL_FLAG"
        "SINGLE_VALUE"
        "MULTI_VALUES")

    # Function body
    target_compile_definitions(${TARGET_NAME} PRIVATE
        MY_DEFINE="${ARG_SINGLE_VALUE}")
endfunction()
```

## Build Configuration

### Default Build Type

```cmake
set(default_build_type "Release")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Setting build type to '${default_build_type}'")
    set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE STRING
        "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
        "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()
```

## Testing Integration

### Enable Testing

```cmake
if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(tests)
endif()
```

### GoogleTest Integration

```cmake
find_package(GTest REQUIRED)
add_executable(test_mylib test_mylib.cpp)
target_link_libraries(test_mylib PRIVATE
    mylib
    GTest::gtest_main)
gtest_discover_tests(test_mylib)
```

## Installation and Export

### Installation Rules

```cmake
install(TARGETS mylib myapp
    EXPORT MyProjectTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include)

install(DIRECTORY include/ DESTINATION include)
```

## Code Style Guidelines

### Naming Conventions

- **Functions/Commands**: `lowercase_with_underscores`
- **Variables**: `UPPERCASE_WITH_UNDERSCORES`
- **Targets**: `lowercase` or `PascalCase`
- **Cache variables**: `UPPERCASE_WITH_UNDERSCORES`

### Formatting

- Use 4 spaces for indentation
- Align multi-line commands consistently
- Keep lines under 80 characters when reasonable
- Use consistent spacing around parentheses

### Comments

```cmake
# Single line comments start with #
# Use comments to explain WHY, not WHAT

#[[
Multi-line comment block
for longer explanations
]]
```

## Error Handling

### Input Validation

```cmake
if(NOT TARGET ${target_name})
    message(FATAL_ERROR "Target ${target_name} does not exist")
endif()
```

### Policies

```cmake
# Handle policy changes explicitly
if(POLICY CMP0077)
    cmake_policy(SET CMP0077 NEW)
endif()
```

## Common Utilities

### Platform Detection

```cmake
if(WIN32)
    # Windows-specific code
elseif(APPLE)
    # macOS-specific code
elseif(UNIX)
    # Linux/Unix-specific code
endif()
```

### Out-of-Source Build Enforcement

```cmake
file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")
    message(FATAL_ERROR "You cannot build in a source directory")
endif()
```

## Best Practices Summary

1. **Always use target-based commands** with visibility specifiers
2. **List sources explicitly** rather than globbing
3. **Use generator expressions** for build-time conditionals
4. **Prefer imported targets** over raw library names
5. **Set CMAKE_MODULE_PATH** for custom Find modules
6. **Use FetchContent** for downloading dependencies
7. **Enable folder support** in IDEs with
   `set_property(GLOBAL PROPERTY USE_FOLDERS ON)`
8. **Test with multiple CMake versions** using version ranges
9. **Document public interfaces** clearly
10. **Follow semantic versioning** for project versions

This guide ensures modern, maintainable CMake code that follows current best
practices and integrates well with modern C++ development workflows.
