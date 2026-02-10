# AGENTS.md

Purpose: Canonical code style guide for automated agents. Follow these rules by
default. Prefer correctness, readability, simplicity, and maintainability over
premature optimization.

## Core Principles

- **Incremental progress over big bangs**: Small changes that compile and pass
  tests
- **Learning from existing code**: Study and plan before implementing
- **Pragmatic over dogmatic**: Adapt to project reality
- **Clear intent over clever code**: Be boring and obvious
- Simplicity Principles:
    - Single responsibility per function/class
    - Avoid premature abstractions
    - No clever tricks - choose the boring solution
    - If you need to explain it, it's too complex
- Architecture Principles:
    - **Composition over inheritance**: Use dependency injection
    - **Interfaces over singletons**: Enable testing and flexibility
    - **Explicit over implicit**: Clear data flow and dependencies
    - **Test-driven when possible**: Never disable tests, fix them

## Development Process

- When generating context, focus on the actual project, avoid looking into
  third-party dependencies unless absolutely necessary.
- Break complex work into 3-5 stages.

### Implementation Flow

1. **Understand**: Study existing patterns in codebase
2. **Test**: Write test first
3. **Implement**: Minimal code to pass
4. **Refactor**: Clean up with tests passing
5. **Commit**: With clear message linking to plan

#### Learning the Codebase

- Find 3 similar features/components
- Identify common patterns and conventions
- Use same libraries/utilities when possible
- Follow existing test patterns

#### When Stuck (After 3 Attempts)

**CRITICAL**: Maximum 3 attempts per issue, then STOP.

## Tooling

- Use project's existing build system
- Use project's test framework
- Use project's formatter/linter settings
- Don't introduce new tools without strong justification

### Toolchain and Build

- Always compile with warnings and optimizations:
    - Flags: -Wall -Wextra -Wpedantic -Wformat=2 -Wno-unused-parameter -Wshadow
      -Wwrite-strings -Wstrict-prototypes -Wold-style-definition
      -Wredundant-decls -Wnested-externs -Wmissing-include-dirs
    - GCC-only extras: -Wjump-misses-init -Wlogical-op
    - Optimization: -O2
- Auto-generate dependencies with -M -MP -MT and include generated .d files.
- Target C99 or newer. Prefer -std=c11 unless C99 is explicitly required by
  tooling; avoid gnu dialects.

## Documentation Standards

- Use American English spelling consistently
- Keep @brief descriptions to single line (under 80 characters)
- Use @details for multi-line explanations
- Always specify parameter directions: `@param[in]`, `@param[out]`,
  `@param[in,out]`
- Document all return values and error conditions explicitly
- Include @pre and @post conditions for complex functions
- Use proper Doxygen markup for cross-references: `@ref TypeName`
- End documentation groups with `/** @} */` where appropriate
- Maintain consistent indentation in documentation blocks
- Use specific, descriptive language avoiding vague terms like "handles stuff"

### Documentation with Docstrings

Follow these documentation patterns for C code:

#### Function Documentation

- Use Doxygen-style comments with `/**` block comments for all public functions
- Place documentation immediately before function declarations in header files
- Structure function documentation in this order:

```c
/**
* @brief          Brief description of what the function does (one line).
* @details        Detailed description explaining behavior, constraints, and
*                 any relevant implementation details. Multiple lines allowed.
*
* @param[in]      ParamName    Description of input parameter, including
*                              valid ranges or special values.
* @param[out]     OutParam     Description of output parameter.
* @param[in,out]  InOutParam   Description of input/output parameter.
*
* @return         ReturnType   Description of return value.
*                 E_OK:        Detailed description of success condition.
*                 E_NOT_OK:    Detailed description of failure condition.
*                 SPECIFIC_ERROR: Description of specific error codes.
*
* @pre            Preconditions that must be satisfied before calling.
* @post           Postconditions that will be true after successful execution.
*/
```

#### Type Documentation

- Document all public types (structs, enums, typedefs) with brief descriptions
- For enums, document each value
- Use `/**< @brief` for inline member documentation:

```c
/**
* @brief          Brief description of the enum purpose.
* @details        Additional details about usage and constraints.
*/
typedef enum
{
    ENUM_VALUE_1 = 0U,  /**< @brief Description of first value */
    ENUM_VALUE_2,       /**< @brief Description of second value */
    ENUM_VALUE_3        /**< @brief Description of third value */
} enum_type_name_t;
```

#### Struct Documentation

- Document structs and their members:

```c
/**
* @brief          Brief description of struct purpose.
* @details        Additional details about usage and member relationships.
*/
typedef struct
{
    uint32_t member_one;     /**< @brief Description of first member */
    bool member_two;         /**< @brief Description of second member */
    enum_type_t member_three; /**< @brief Description of third member */
} struct_type_name_t;
```

#### Variable Documentation

- Document global variables and static variables with significant scope:

```c
/**
* @brief          Brief description of variable purpose.
* @details        Detailed explanation of usage, lifetime, and constraints.
*/
static variable_type_t s_variable_name;

/**
* @brief          Global Configuration Pointer.
* @details        Data structure containing the set of configuration parameters
*                 required for initializing the driver and hardware units.
*/
const config_type_t * g_config_ptr[MAX_INSTANCES];
```

#### File-Level Documentation

- Include file header with module information:

```c
/**
*   @file    ModuleName.h
*   @implements      ModuleName.h_Artifact
*   @addtogroup module_driver
*   @{
*/
```

## C Code Style

Follow these C coding conventions consistently across the codebase.

### Formatting and Layout

- Indentation: spaces only (no tabs). Configure editors to insert spaces on TAB.
  No literal tab characters (ASCII 0x09) in source files.
- Max line length: 80 characters hard limit.
- Always use braces for control blocks, even single statements, and place the
  opening brace on its own line below the control statement. Do not place
  statements on the same line as conditions.
- Prefer // comments; /_ ... _/ is permitted. Do not nest comment tokens and
  never comment out code to disable functionality; use #if 0 ... #endif or
  #ifndef NDEBUG for debug-only code. Extensive documentation with /\*_ ... _/
  blocks is required for public APIs.
- Separate top-level functions and type definitions by two blank lines; keep at
  most one blank line within functions.
- Comment closing #endif for large conditionals.
- American English for code, comments, and docs.

### Naming

- Structs: lower_case with \_s suffix (struct name_s {...}).
- Enums: lower_case with \_e suffix; constants in UPPER_CASE (e.g., enum
  json_type_e { JSON_TYPE_NUMBER }). Define a constant with enum size (prefer
  #define NUM_TYPES N).
- Typedefs: lower_case with \_t suffix (e.g., timer_reg_t).
- Functions: lower_case.
- Variables and parameters: lower_case (exception: register struct members use
  UPPER_CASE).
- Global and static constants: UPPER_CASE.
- Never begin identifiers with \_.
- Be consistent in variable naming across functions; short names are fine in
  small scopes.
- Macro naming:
    - All macros and named constants: UPPER_CASE.
    - If a macro is specific to one function, define it within that function.

### Types and Declarations

- Prefer double over float unless a measured need says otherwise.
- Use bool from stdbool.h for booleans.
- Avoid unsigned for general counts; integer conversion rules are tricky. Use
  long/long long for range; only use unsigned where required (bit ops, modular
  overflow), and isolate them.
- Declare variables as late as possible; one variable per line. Initialize upon
  declaration when possible, except when using error handling patterns that
  require deferred initialization for cleanup.
- Prefer array indexing over pointer arithmetic for clarity.
- Do not use array syntax in function parameters; arrays decay to pointers. Use
  plural names for pointer-to-array parameters to signal intent.
- sizeof: prefer using the variable, not the type (sizeof \*p). For compound
  literals you may need sizeof(type).
- Strings: initialize as arrays and use sizeof arr for byte counts. Compile with
  -Wwrite-strings.
- Avoid variable-length arrays; use dynamic allocation instead.
- Avoid void\* when possible; when present, cast to a typed pointer ASAP.
- Use C11 anonymous structs/unions to encode mutually exclusive fields.

### const and Immutability

- Use const wherever possible: for read-only variables, pointer pointees, and
  function parameters.
- Place const on the right and read types right-to-left, e.g., char const \*
  const p;
- Do not add const qualifiers to pointer-to-pointer return/args unless
  necessary; be cautious with pointee-pointees in C.
- Do not cast away const or rely on tricks to bypass it.
- Function prototypes: omit parameter names unless a pointer needs
  singular/plural clarity. Never add redundant const to parameter identifiers in
  prototypes (only to types).

### Expressions and Control Flow

- Do not mutate within expressions (no ++/--/assignments inside conditions).
  Prefer += 1 / -= 1 in statements; avoid ++/-- entirely.
- Avoid non-pure or non-trivial function calls inside expressions; assign result
  to a named variable, then test/use it.
- Use parentheses when precedence is not obvious; exceptions for common
  boolean/equality combos.
- Use switch sparingly. When used, align case labels, indent case bodies one
  level, and always include a default block. Prefer if/else or function-pointer
  dispatch if it improves clarity.
- Keep boolean logic explicit; prefer explicit comparisons over relying on
  truthiness. Predicates can be used directly.
- Multiple returns makes understanding code flow harder. Prefer single exit
  point per function. See _Error Handling_
- Avoid complex branches; use early returns for error conditions.

### APIs, Pointers, and Mutability

- Only use pointer parameters for:
    - Nullability (optional values)
    - Arrays
    - Modifications (the object or its pointees)
- Prefer returning new values over mutating via pointers; aim for pure functions
  and immutability.
- For public structs:
    - Minimize pointer fields unless for nullity, dynamic arrays, or
      incomplete/self types.
    - Document invariants and provide is_valid/assert_valid helpers.
- Avoid getters/setters; prefer direct member access. Provide functional,
  declarative constructors/configurators.

### Macros and Literals

- Do not provide macros that wrap control structures (e.g., foreach-style
  loops).
- Prefer compound literals to temporary variables when limiting scope and
  improving clarity, especially for syscalls/APIs expecting struct pointers.
- Always use designated initializers for struct literals; consider documented
  exceptions for a first "positional" field in named-argument wrappers.

### Assertions and Validation

- Use assert to catch programmer errors and fail fast; never rely on assert for
  user input validation or correctness.
- Write multiple assert calls rather than chaining with && to improve
  diagnostics.

### Examples and Patterns

- Function pointer dispatch:
    - Prefer get_action(x) returning a function pointer and call it, instead of
      switch.

- Optional arguments via named struct:
    - Use a macro wrapper that builds a designated-initialized options struct
      with defaults:
        - #define run*server(...) run_server*((struct run_server_options){
          .port="45680", .backlog=5, **VA_ARGS** })
        - int run*server*(struct run_server_options opts);

- Enum size constant:
    - enum suit_e { SUIT_HEARTS, SUIT_DIAMONDS, SUIT_CLUBS, SUIT_SPADES };
    - #define NUM_SUITS 4

- sizeof with allocation:
    - T _p = malloc(n _ sizeof \*p);

- String as array:
    - char const msg[] = "hello";
    - write(fd, msg, sizeof msg);

### Error Handling

- Fail fast with descriptive messages
- Include context for debugging
- Handle errors at appropriate level
- Never silently swallow exceptions

#### Error Handling and Resource Management

- Centralize cleanup with a single exit path to simplify error handling:
    - Multiple returns make it easy to miss frees. Use goto for cleanup patterns
      to ensure every resource is released exactly once.

- goto for Error Handling:
    - goto is acceptable and recommended for error recovery and resource cleanup
      in C.
    - Use descriptive labels like `error_1`, `cleanup`, or `out` that indicate
      their purpose.
    - Structure cleanup labels in reverse order of resource allocation for
      proper LIFO cleanup.
    - Keep mainline code readable by placing error handling at the end with goto
      jumps.

- Error Handling Pattern:

    ```c
    int function_with_resources(void)
    {
        int result = 0;
        resource_type *res1 = NULL;
        resource_type *res2 = NULL;

        res1 = allocate_resource_1();
        if (!res1)
        {
            result = -1;
            goto cleanup;
        }

        res2 = allocate_resource_2();
        if (!res2)
        {
            result = -2;
            goto cleanup_res1;
        }

        // mainline code here
        result = do_work(res1, res2);

    cleanup_res2:
        if (res2)
            free_resource_2(res2);
    cleanup_res1:
        if (res1)
            free_resource_1(res1);
    cleanup:
        return result;
    }
    ```

- Additional goto uses:
    - Breaking out of deeply nested loops (2+ levels) when encountering special
      conditions.
    - Avoid goto for regular control flow; use only for error handling and deep
      loop exits.

### Includes and Headers

- For every used symbol, explicitly #include the defining header (do not rely on
  transitive includes).
- All headers must have include guards.
- Never rely on users to include headers required by your headers.

#### Include File Order

Include files must appear in the following order, with blank lines separating
each group:

1. **Own header file** (for .c files only):
    - #include "module.h" (corresponding header for this .c file)

2. **Standard C library headers** (alphabetical order):
    - #include <assert.h>
    - #include <stdio.h>
    - #include <stdlib.h>
    - #include <string.h>

3. **POSIX/system headers** (alphabetical order):
    - #include <sys/types.h>
    - #include <unistd.h>

4. **Third-party library headers** (alphabetical order within each library):
    - Group by library, then alphabetical within each group
    - #include <openssl/ssl.h>
    - #include <zlib.h>

5. **Project headers** (alphabetical order):
    - #include "config.h"
    - #include "utils.h"

#### Include Comments

- Comment non-libc includes with exported symbols used, e.g.:
    - #include "trie.h" // Trie, Trie\_\*
    - #include "parser.h" // parse_config, config_node_t
- Standard library includes typically don't need comments unless using obscure
  functions
- Avoid unified "catch-all" headers; keep headers modular

### Example Include Order

```c
// For file: network_client.c
#include "network_client.h"

#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <arpa/inet.h>
#include <sys/socket.h>
#include <unistd.h>

#include <openssl/ssl.h>

#include "config.h"     // config_t, load_config
#include "logger.h"     // log_error, log_info
#include "protocol.h"   // message_t, serialize_message
```

### Strings

- C strings shall be limited to the basic execution character set as defined by
  the ISO C standard, to ensure functional safety and cross-platform portability

#### Prohibited characters:

- Any character with a value outside the 7-bit ASCII range (0x00–0x7F),
  excluding '\0'
- Locale-dependent or implementation-defined characters
- Multi-byte or wide characters (e.g. UTF-8 sequences, wchar_t)
- Embedded null characters within a string

### Bare metal and low-level programming patterns

The following instructions are only applicable for low-level, bare-metal, or
embedded C programming, especially when dealing with hardware registers and
memory-mapped I/O.

#### Register Access and Memory-Mapped I/O

##### Register Structure Definitions

When defining memory-mapped peripheral registers, follow these patterns:

- Use `__IO`, `__I`, and `__O` qualifiers for register access types:
    - `__IO uint32_t` for read/write registers
    - `__I uint32_t` for read-only registers
    - `__O uint32_t` for write-only registers
- Include explicit padding with `uint8_t RESERVED_x[n]` for alignment
- Use arrays for repeated register blocks: `uint32_t REGISTER[COUNT]`
- Document register bit fields and reset values in comments

```c
/* IO definitions (access restrictions to peripheral registers) */
/**
*   IO Type Qualifiers are used
*   \li to specify the access to peripheral variables.
*   \li for automatic generation of peripheral register debug information.
*/
#define     __I     volatile const       /*!< Defines 'read only' permissions                 */
#define     __O     volatile             /*!< Defines 'write only' permissions                */
#define     __IO    volatile             /*!< Defines 'read / write' permissions              */
```

```c
/**
* @brief          Analog-to-Digital Converter Register Structure
* @details        Memory-mapped structure for ADC peripheral registers
*/
typedef struct
{
    __IO uint32_t MCR;                    /**< @brief Main Configuration Register */
    __IO uint32_t MSR;                    /**< @brief Main Status Register */
    uint8_t RESERVED_0[8];                /**< @brief Reserved space 0x008-0x00F */
    __IO uint32_t ISR[ADC_ISR_COUNT];     /**< @brief Interrupt Status Registers */
    __I uint32_t CEOCFR[ADC_CEOCFR_COUNT]; /**< @brief Channel End of Conversion Flag */
    uint8_t RESERVED_1[12];               /**< @brief Reserved space 0x0A4-0x0AF */
    __IO uint32_t IMR;                    /**< @brief Interrupt Mask Register */
    uint8_t RESERVED_2[12];               /**< @brief Reserved space 0x0B4-0x0BF */
    __IO uint32_t CIMR[ADC_CIMR_COUNT];   /**< @brief Channel Interrupt Mask Registers */
} ADC_Type;
```

#### Base Address and Instance Definitions

- Define base addresses as macros with explicit casting
- Provide typed pointer definitions for each peripheral instance
- Use array initializers for multiple instances

```c
/** @brief ADC base addresses */
#define ADC_0_BASE                       (0x401F8000UL)
#define ADC_1_BASE                       (0x402F8000UL)
#define ADC_2_BASE                       (0x403F8000UL)

/** @brief ADC peripheral instances */
#define ADC_0                            ((ADC_Type *)ADC_0_BASE)
#define ADC_1                            ((ADC_Type *)ADC_1_BASE)
#define ADC_2                            ((ADC_Type *)ADC_2_BASE)

/** @brief ADC instance array */
#define ADC_INSTANCE_COUNT               (3U)
static ADC_Type * const ADC_INSTANCES[ADC_INSTANCE_COUNT] =
{
    ADC_0,
    ADC_1,
    ADC_2
};
```

#### Register Access Patterns

- Access registers through structure members, not raw addresses
- Use bit field macros for register manipulation
- Always validate instance parameters in public APIs
- Document register access requirements (atomic, ordering, etc.)

```c
/**
* @brief          Configure ADC main control register
* @details        Sets up ADC operation mode and enables the peripheral
*
* @param[in]      instance    ADC instance (0-2)
* @param[in]      config      Configuration value
*
* @pre            ADC instance must be valid (0 <= instance < ADC_INSTANCE_COUNT)
* @post           ADC peripheral configured according to config value
*/
void adc_configure_main_control(uint32_t instance, uint32_t config)
{
    assert(instance < ADC_INSTANCE_COUNT);
    assert(ADC_INSTANCES[instance] != NULL);

    ADC_Type * const base = ADC_INSTANCES[instance];
    base->MCR = config;
}
```

#### Memory Barrier and Ordering

- Use memory barriers when register ordering is critical
- Document synchronization requirements
- Consider volatile semantics for register access

```c
/**
* @brief          Write register with memory barrier
* @details        Ensures write completes before subsequent operations
*/
static inline void reg_write_barrier(volatile uint32_t * reg, uint32_t value)
{
    *reg = value;
    __DSB();  // Data Synchronization Barrier
}
```

#### Register Bit Field Definitions

- Define bit positions and masks as macros
- Group related bit fields logically
- Use consistent naming conventions

```c
/** @brief ADC Main Control Register (MCR) bit definitions */
#define ADC_MCR_PWDN_MASK                (0x1UL)
#define ADC_MCR_PWDN_SHIFT               (0UL)
#define ADC_MCR_PWDN_WIDTH               (1UL)
#define ADC_MCR_PWDN(x)                  (((uint32_t)(x) << ADC_MCR_PWDN_SHIFT) & ADC_MCR_PWDN_MASK)

#define ADC_MCR_ADCLKSE_MASK             (0x100UL)
#define ADC_MCR_ADCLKSE_SHIFT            (8UL)
#define ADC_MCR_ADCLKSE_WIDTH            (1UL)
#define ADC_MCR_ADCLKSE(x)               (((uint32_t)(x) << ADC_MCR_ADCLKSE_SHIFT) & ADC_MCR_ADCLKSE_MASK)
```

## Deviations

Only deviate when:

- Benchmarks after a complete, correct implementation demonstrate a measurable
  benefit.
- A platform/compiler constraint prevents compliance (document it).
- Interop with external APIs requires a specific pattern (contain the deviation
  and document it).
