# SEI CERT C Coding Standard Guidelines for AI Agents

**Source**: SEI CERT C Coding Standard: Rules for Developing Safe, Reliable, and
Secure Systems — Software Engineering Institute, Carnegie Mellon University.

## Purpose

These rules define mandatory constraints for generating safe, reliable, and
secure C code. Every rule listed here represents a class of defect that leads to
undefined behavior, security vulnerabilities, or unreliable programs. AI agents
must apply all applicable rules when writing or modifying C code.

---

## 1. Preprocessor (PRE)

### PRE30-C — Do not create a universal character name through concatenation

- Never produce a universal character name (`\uXXXX` or `\UXXXXXXXX`) as a side
  effect of token concatenation with `##`.
- The result of such concatenation is undefined.

### PRE31-C — Avoid side effects in arguments to unsafe macros

- Macros that expand their arguments more than once (unsafe macros) must not
  receive arguments with side effects (e.g., `i++`, function calls with
  observable effects).
- If the macro is not under your control, assign the argument to a temporary
  variable and pass that instead.

### PRE32-C — Do not use preprocessor directives inside function-like macro invocations

- Preprocessor directives (`#if`, `#define`, `#include`, etc.) must not appear
  inside the argument list of a function-like macro invocation.
- The behavior is undefined.

---

## 2. Declarations and Initialization (DCL)

### DCL30-C — Declare objects with appropriate storage durations

- Never return a pointer to, or store the address of, an automatic (stack)
  variable that will be out of scope when the pointer is used.
- Use `static`, dynamic allocation, or pass a caller-supplied buffer instead.

### DCL31-C — Declare identifiers before using them

- All identifiers (variables, functions, types) must be declared before first
  use.
- Do not rely on implicit `int` declarations (banned in C99 and later).

### DCL36-C — Do not declare an identifier with conflicting linkage classifications

- An identifier with external linkage must not also appear with internal linkage
  in the same translation unit, or vice versa.

### DCL37-C — Do not declare or define a reserved identifier

- Identifiers beginning with `_` followed by an uppercase letter, or with `__`
  anywhere, are reserved by the implementation.
- Do not declare, define, or `#undef` such identifiers.
- Do not redefine or shadow standard library names.

### DCL38-C — Use the correct syntax when declaring a flexible array member

- Flexible array members must be declared as the last member of a struct with at
  least one other named member, using the syntax `type name[];` (no size).
- Do not use `[0]` or `[1]` as a substitute.

### DCL39-C — Avoid information leakage when passing a structure across a trust boundary

- Padding bytes inside structures have indeterminate values.
- Zero-initialize the entire structure (e.g., with `memset` or a compound
  literal with `= {0}`) before copying it to an untrusted context or writing it
  to persistent storage or a network.

### DCL40-C — Do not create incompatible declarations of the same function or object

- All declarations of the same function or object across translation units must
  be compatible (same type, same parameter types).
- Use a shared header to provide a single authoritative declaration.

### DCL41-C — Do not declare variables inside a switch statement before the first case label

- Declarations placed between the `switch` keyword and the first `case` label
  are in scope for all cases but their initializers may be skipped.
- Move such declarations outside the `switch`, or restructure using blocks.

---

## 3. Expressions (EXP)

### EXP30-C — Do not depend on the order of evaluation for side effects

- The order in which sub-expressions and function arguments are evaluated is
  unspecified.
- Never write expressions in which the outcome depends on evaluation order
  (e.g., `a[i] = i++`).
- Split such expressions across separate statements.

### EXP32-C — Do not access a volatile object through a non-volatile reference

- Accessing a `volatile` object through a non-`volatile` qualified pointer or
  reference removes the required memory access semantics.
- Always use a `volatile`-qualified lvalue to access a `volatile` object.

### EXP33-C — Do not read uninitialized memory

- Reading an indeterminate value produces undefined behavior.
- Initialize all variables at the point of declaration, or guarantee
  initialization on all paths before first read.

### EXP34-C — Do not dereference null pointers

- Check every pointer that may be null before dereferencing it.
- This includes return values of allocation functions (`malloc`, `calloc`,
  `realloc`) and functions that return pointers on success and `NULL` on
  failure.

### EXP35-C — Do not modify objects with temporary lifetime

- The result of certain operations (e.g., accessing a member of a struct
  returned by value) has temporary lifetime; modifying it is undefined.
- Assign the returned value to a named object before modifying it.

### EXP36-C — Do not cast pointers into more strictly aligned pointer types

- Casting a pointer to a type with stricter alignment requirements than the
  original type and then dereferencing it is undefined behavior.
- Use `memcpy` to transfer data between incompatibly aligned regions.

### EXP37-C — Call functions with the correct number and type of arguments

- Always include the function prototype in scope before calling the function.
- Pass arguments that match the declared parameter types exactly, including
  correct pointer levels.

### EXP39-C — Do not access a variable through a pointer of an incompatible type

- Type-punning through incompatible pointer casts (other than `unsigned char *`
  or `char *`) violates strict aliasing and produces undefined behavior.
- Use `memcpy` or a `union` (with appropriate care) for type-punning.

### EXP40-C — Do not modify constant objects

- Never cast away `const` in order to modify the underlying object.
- Objects declared `const` must not be modified through any means.

### EXP42-C — Do not compare padding data

- Structure padding bytes have indeterminate values.
- Do not use `memcmp` to compare structures; compare field by field instead, or
  ensure the structures are fully initialized (including padding) with `memset`.

### EXP43-C — Avoid undefined behavior when using restrict-qualified pointers

- Objects pointed to by `restrict`-qualified pointers must not alias each other
  or any other object accessed in the same scope.
- Verify that actual arguments to `restrict`-annotated parameters are
  non-overlapping.

### EXP44-C — Do not rely on side effects in operands to sizeof, \_Alignof, or \_Generic

- The operand of `sizeof`, `_Alignof`, and the controlling expression of
  `_Generic` are not evaluated (except when `sizeof` is applied to a
  variable-length array).
- Do not place expressions with side effects inside these operators.

### EXP45-C — Do not perform assignments in selection statements

- Assignments inside `if`, `while`, `for`, or `switch` conditions are a frequent
  source of bugs and obscure intent.
- Perform the assignment in a separate statement before the condition.

### EXP46-C — Do not use a bitwise operator with a Boolean-like operand

- Using `&`, `|`, or `^` instead of `&&`, `||` with Boolean-valued operands is
  almost always a defect and eliminates short-circuit evaluation.
- Use logical operators (`&&`, `||`) for Boolean logic.

---

## 4. Integers (INT)

### INT30-C — Ensure that unsigned integer operations do not wrap

- Unsigned arithmetic wraps modulo 2^N; unintended wrap is a defect.
- Before addition: check `UINT_MAX - a >= b`.
- Before multiplication: check `a == 0 || b <= UINT_MAX / a`.
- Before subtraction: check `a >= b`.

### INT31-C — Ensure that integer conversions do not result in lost or misinterpreted data

- Conversions that truncate a value or change its sign produce unexpected
  results.
- Validate that the value fits in the destination type before converting.
- Be especially cautious converting `signed` to `unsigned` and vice versa.

### INT32-C — Ensure that operations on signed integers do not result in overflow

- Signed integer overflow is undefined behavior.
- Check operands before performing addition, subtraction, multiplication, or
  negation on signed integers.
- Use range checks or, when available, compiler built-ins
  (`__builtin_add_overflow`, etc.).

### INT33-C — Ensure that division and remainder operations do not result in divide-by-zero

- Check the divisor is non-zero before every `/` or `%` operation.
- For signed integers also guard against the `INT_MIN / -1` overflow case.

### INT34-C — Do not shift by a negative amount or by >= the bit width of the operand

- Shifting by a negative count or by a count >= the width of the type is
  undefined behavior.
- Validate the shift count is in `[0, sizeof(type)*CHAR_BIT - 1]` before
  shifting.
- For left shifts on signed types also ensure no overflow occurs.

### INT35-C — Use correct integer precisions

- Use types of sufficient width for the values they must hold.
- Prefer `<stdint.h>` fixed-width types (`uint32_t`, `int64_t`, etc.) when
  precise width matters.
- Avoid assuming that `int`, `long`, or `size_t` have any particular width.

### INT36-C — Converting a pointer to integer or integer to pointer

- Only convert a pointer to an integer type that is guaranteed to be large
  enough to hold all pointer values (i.e., `uintptr_t` or `intptr_t`).
- Converting back to a pointer is only valid if the integer was originally
  obtained by converting that pointer, or points to a validly allocated object.

---

## 5. Floating Point (FLP)

### FLP30-C — Do not use floating-point variables as loop counters

- Floating-point representation errors accumulate across iterations, causing
  loops to execute the wrong number of times.
- Use an integer counter and compute the floating-point value from it if needed.

### FLP32-C — Prevent or detect domain and range errors in math functions

- Functions such as `sqrt`, `log`, `pow`, and trigonometric functions have
  restricted domains.
- Validate arguments before calling, or check `errno` and the return value
  (`HUGE_VAL`, `NAN`) after calling.

### FLP34-C — Ensure that floating-point conversions are within range of the new type

- Converting a `double` to `float` or a floating-point value to an integer when
  the value is out of range is undefined behavior.
- Range-check the value before conversion.

### FLP36-C — Preserve precision when converting integral values to floating-point type

- Not all integer values are exactly representable in floating-point.
- When converting large integers to `float` or `double`, be aware of precision
  loss and document or mitigate it.

### FLP37-C — Do not use object representations to compare floating-point values

- Do not use `memcmp` or bitwise tricks to compare floating-point values.
- Use arithmetic comparisons, applying an appropriate epsilon where exact
  equality is not meaningful.

---

## 6. Arrays (ARR)

### ARR30-C — Do not form or use out-of-bounds pointers or array subscripts

- Any pointer arithmetic that produces a pointer outside `[array, array+n]`
  (where `n` is the array size) is undefined behavior, even if the pointer is
  never dereferenced.
- Validate all indices against array bounds before access.

### ARR32-C — Ensure size arguments for variable-length arrays are in a valid range

- A zero or negative size for a VLA is undefined behavior.
- Validate that the size is positive and within a safe limit before declaring
  the VLA.

### ARR36-C — Do not subtract or compare two pointers that do not refer to the same array

- Pointer subtraction and relational comparison (`<`, `>`, `<=`, `>=`) are only
  defined for pointers into (or one past the end of) the same array object.

### ARR37-C — Do not add or subtract an integer to a pointer to a non-array object

- Pointer arithmetic is only defined when the pointer points into an array (a
  single object counts as a one-element array).
- Do not perform arithmetic on pointers to scalar objects.

### ARR38-C — Guarantee that library functions do not form invalid pointers

- Functions such as `memcpy`, `memmove`, `strcpy`, and `strncpy` require that
  the destination and source regions are valid and of sufficient size.
- Always pass correct size arguments; never allow overlap for functions that do
  not support it.

### ARR39-C — Do not add or subtract a scaled integer to a pointer

- Adding a value that has already been multiplied by the element size (i.e.,
  manual byte-level indexing into a typed pointer) produces an incorrectly
  scaled offset.
- Let the compiler scale the offset by using normal array indexing or pointer
  arithmetic on the correct type.

---

## 7. Characters and Strings (STR)

### STR30-C — Do not attempt to modify string literals

- String literals have static storage duration and may reside in read-only
  memory.
- Declare string variables as `char []` (arrays) rather than `char *` when
  modification is required, or use `strdup`.

### STR31-C — Guarantee that storage for strings has sufficient space for character data and the null terminator

- Always allocate `strlen(src) + 1` bytes (or more) for a destination string.
- Be especially careful with `strcat`, `strcpy`, and `sprintf`.

### STR32-C — Do not pass a non-null-terminated character sequence to a library function that expects a string

- Functions such as `strlen`, `strcpy`, `printf("%s", ...)` require a null
  terminator.
- Ensure all character buffers are properly null-terminated before passing them
  to such functions.

### STR34-C — Cast characters to unsigned char before converting to larger integer sizes

- Plain `char` may be signed; values > 127 will sign-extend when promoted to
  `int`, producing negative values where positive ones are expected.
- Cast to `unsigned char` first: `(unsigned char)c`.

### STR37-C — Arguments to character-handling functions must be representable as unsigned char

- Functions declared in `<ctype.h>` (e.g., `isalpha`, `toupper`) require that
  the argument is in the range `[0, UCHAR_MAX]` or is `EOF`.
- Cast the argument to `unsigned char` before passing.

### STR38-C — Do not confuse narrow and wide character strings and functions

- Never mix `char *` strings with wide-character functions (`wcslen`, `wcscpy`,
  etc.) or `wchar_t *` strings with narrow-character functions.
- Match the string type to the function family consistently.

---

## 8. Memory Management (MEM)

### MEM30-C — Do not access freed memory

- After calling `free(p)`, the pointer `p` is a dangling pointer.
- Set the pointer to `NULL` immediately after freeing.
- Never pass a freed pointer to `free` a second time (double-free).

### MEM31-C — Free dynamically allocated memory when no longer needed

- Every successful call to `malloc`, `calloc`, `realloc`, or `strdup` must have
  a corresponding `free` on all code paths, including error paths.
- Use the cleanup (goto) pattern to ensure memory is always freed.

### MEM33-C — Allocate and copy structures containing a flexible array member dynamically

- Structures with flexible array members must be allocated with `malloc` using
  `sizeof(struct s) + n * sizeof(element_type)`.
- Do not copy such structures with assignment (`s1 = s2`) — this copies only the
  fixed members. Use `memcpy` with the full allocated size.

### MEM34-C — Only free memory allocated dynamically

- Never call `free` on a pointer to a stack variable, a static variable, a
  string literal, or any object not returned by a heap allocation function.

### MEM35-C — Allocate sufficient memory for an object

- Always allocate `sizeof(T)` bytes (or more) for a pointer-to-`T`.
- Do not use hardcoded sizes that may be wrong on some platforms.
- Prefer `sizeof *ptr` over `sizeof(type)` to stay correct through type changes.

### MEM36-C — Do not modify the alignment of objects by calling realloc()

- `realloc` may return a pointer with less strict alignment than required by the
  object type.
- Use `malloc`/`free` instead when alignment is critical, or check that the
  returned pointer satisfies the required alignment.

---

## 9. Input/Output (FIO)

### FIO30-C — Exclude user input from format strings

- Never pass user-controlled data as the format string argument to `printf`,
  `fprintf`, `sprintf`, `snprintf`, `syslog`, etc.
- Use a fixed format string with `%s` (or similar) to incorporate user data.

### FIO32-C — Do not perform operations on devices that are only appropriate for files

- Functions such as `fseek`, `ftell`, and `rewind` may not work correctly on
  non-regular files (e.g., terminals, pipes, sockets).
- Check that the stream refers to a regular file before using these functions,
  or use only portable I/O operations.

### FIO34-C — Distinguish between characters read from a file and EOF or WEOF

- `getc` and related functions return `int`, not `char`.
- Store the return value in an `int` before comparing with `EOF`; storing in
  `char` loses the distinction.

### FIO37-C — Do not assume that fgets() or fgetws() returns a non-empty string when successful

- A successful `fgets` call may return a string containing only a newline if the
  input begins with one.
- Check the actual content of the buffer rather than just the return value.

### FIO38-C — Do not copy a FILE object

- `FILE` objects must not be copied with assignment or `memcpy`.
- Always use the pointer returned by `fopen` or `fdopen`; never make copies of
  the `FILE` struct itself.

### FIO39-C — Do not alternately input and output from a stream without an intervening flush or positioning call

- When a stream is opened for both reading and writing, switch from output to
  input only after `fflush`, `fseek`, `fsetpos`, or `rewind`; and switch from
  input to output only after reaching EOF or after a positioning call.

### FIO40-C — Reset strings on fgets() or fgetws() failure

- If `fgets` or `fgetws` fails (returns `NULL`), the buffer content is
  indeterminate.
- Set the buffer to a known state (e.g., `buf[0] = '\0'`) before any further
  use.

### FIO41-C — Do not call getc(), putc(), getwc(), or putwc() with a stream argument that has side effects

- These functions may evaluate the stream argument more than once.
- Pass only a simple variable, not an expression with side effects.

### FIO42-C — Close files when they are no longer needed

- Every `fopen` must have a corresponding `fclose` on all code paths, including
  error paths.
- Use the cleanup (goto) pattern to guarantee files are closed.

### FIO44-C — Only use values for fsetpos() that are returned from fgetpos()

- Do not construct or modify `fpos_t` values manually.
- Only pass to `fsetpos` a value that was obtained from a prior call to
  `fgetpos` on the same stream.

### FIO45-C — Avoid TOCTOU race conditions while accessing files

- Do not check file properties (existence, permissions) with one call and act on
  them with another; the file state can change between the two.
- Use atomic open-and-create patterns (`O_CREAT | O_EXCL`) and operate on file
  descriptors rather than file names after opening.

### FIO46-C — Do not access a closed file

- After `fclose(fp)`, the pointer `fp` is invalid.
- Set it to `NULL` immediately after closing and do not pass it to any further
  I/O functions.

### FIO47-C — Use valid format strings

- Format strings must be syntactically correct and the number and types of
  arguments must match the format specifiers exactly.
- Mismatches produce undefined behavior.
- Use compiler warnings (`-Wformat`, `-Wformat-security`) to catch errors.

---

## 10. Environment (ENV)

### ENV30-C — Do not modify the object referenced by the return value of certain functions

- Functions such as `getenv`, `setlocale`, `localeconv`, `asctime`, and
  `strerror` return pointers to internal static buffers that must not be
  modified.
- Copy the result to a local buffer before making any modifications or calling
  the function again.

### ENV31-C — Do not rely on an environment pointer following an operation that may invalidate it

- The `environ` pointer and pointers returned by `getenv` may be invalidated by
  subsequent calls to `setenv`, `unsetenv`, or `putenv`.
- Copy the value immediately after retrieval.

### ENV32-C — All exit handlers must return normally

- Functions registered with `atexit` or `at_quick_exit` must return normally;
  they must not call `exit`, `quick_exit`, `longjmp`, or throw exceptions.

### ENV33-C — Do not call system()

- `system()` passes a string to the host shell, which is vulnerable to command
  injection and inherits the process's environment.
- Use `exec`-family functions with explicitly constructed argument arrays
  instead.

### ENV34-C — Do not store pointers returned by certain functions

- Pointers returned by `getenv`, `asctime`, `ctime`, `gmtime`, `localtime`, and
  similar functions point to statically allocated memory that may be overwritten
  by the next call to the same function.
- Copy the pointed-to data before the next call.

---

## 11. Signals (SIG)

### SIG30-C — Call only asynchronous-safe functions within signal handlers

- A signal handler must call only functions that are async-signal-safe (as
  listed in POSIX).
- In particular, do not call `printf`, `malloc`, `free`, `exit`, or any function
  that acquires a lock from within a signal handler.
- Set a `volatile sig_atomic_t` flag and check it from the main program.

### SIG31-C — Do not access shared objects in signal handlers

- Signal handlers must not read or write objects that are shared with the rest
  of the program, except for objects of type `volatile sig_atomic_t`.

### SIG34-C — Do not call signal() from within interruptible signal handlers

- Calling `signal()` inside a signal handler to re-install the handler creates a
  race condition.
- Use `sigaction` with `SA_RESETHAND` cleared, or set up the handler with
  `sigaction` in the first place.

### SIG35-C — Do not return from a computational exception signal handler

- Returning from a signal handler for `SIGFPE`, `SIGILL`, or `SIGSEGV` results
  in undefined behavior because the faulting instruction is re-executed.
- Use `longjmp` (with extreme care), `_exit`, or abort execution instead.

---

## 12. Error Handling (ERR)

### ERR30-C — Set errno to zero before calling a library function known to set errno, and check errno only after the function returns a value indicating failure

- `errno` may be non-zero from a prior call.
- Set `errno = 0` immediately before the call, then check the return value
  first; only inspect `errno` when the return value signals an error.

### ERR32-C — Do not rely on indeterminate values of errno

- Some functions do not set `errno` on success.
- Do not read `errno` unless the function's documented contract says it sets it
  and the function has returned an error indicator.

### ERR33-C — Detect and handle standard library errors

- Every standard library call that can fail must have its return value checked.
- Do not silently ignore error returns from `fopen`, `malloc`, `fclose`,
  `printf`, `scanf`, and similar functions.

---

## 13. Concurrency (CON)

### CON30-C — Clean up thread-specific storage

- Call `pthread_key_delete` to release thread-specific data keys when they are
  no longer needed, after ensuring all threads have exited.

### CON31-C — Do not destroy a mutex while it is locked

- Destroying a mutex (with `pthread_mutex_destroy`) that is currently locked or
  is being waited on produces undefined behavior.
- Ensure all threads have unlocked and are done with the mutex before destroying
  it.

### CON32-C — Prevent data races when accessing bit-fields from multiple threads

- Bit-fields within the same storage unit share underlying memory; concurrent
  access to different bit-fields in the same unit without synchronization is a
  data race.
- Protect the entire storage unit with a mutex, or restructure to use separate
  `_Atomic` variables.

### CON33-C — Avoid race conditions when using library functions

- Many standard library functions use internal static state and are not
  thread-safe (e.g., `strtok`, `rand`, `asctime`, `localtime`).
- Use re-entrant alternatives (`strtok_r`, `rand_r`, etc.) or protect calls with
  a mutex.

### CON34-C — Declare objects shared between threads with appropriate storage durations

- Objects accessed by multiple threads must have a lifetime that encompasses all
  accesses.
- Do not pass pointers to automatic (stack) variables to other threads unless
  the creating thread is guaranteed to outlive all uses.

### CON35-C — Avoid deadlock by locking in a predefined order

- When multiple mutexes must be acquired, always acquire them in the same global
  order across all threads.
- Document and enforce the locking order.

### CON36-C — Wrap functions that can spuriously wake up in a loop

- Condition variable waits (`pthread_cond_wait`) can return without the
  condition being true.
- Always re-check the predicate in a `while` loop:

```c
while (!condition_is_true)
{
    pthread_cond_wait(&cond, &mutex);
}
```

### CON37-C — Do not call signal() in a multithreaded program

- The behavior of `signal()` in a multithreaded program is undefined on many
  implementations.
- Use `sigaction` and `pthread_sigmask` / `sigwait` for signal handling in
  multithreaded code.

### CON38-C — Preserve thread safety and liveness when using condition variables

- Always hold the associated mutex when calling `pthread_cond_signal` or
  `pthread_cond_broadcast` (unless the implementation guarantees otherwise).
- Ensure the predicate is set under the mutex before signaling.

### CON39-C — Do not join or detach a thread that was previously joined or detached

- Calling `pthread_join` or `pthread_detach` on a thread that has already been
  joined or detached produces undefined behavior.
- Track thread state and perform join/detach exactly once per thread.

### CON40-C — Do not refer to an atomic variable twice in an expression

- Two references to the same `_Atomic` variable in one expression do not
  guarantee a single atomic operation across both reads/writes.
- Use a local copy or `atomic_compare_exchange` to implement compound atomic
  operations correctly.

### CON41-C — Wrap functions that can fail spuriously in a loop

- Compare-and-exchange operations (`atomic_compare_exchange_weak`) may fail
  spuriously.
- Always place the weak form in a loop; reserve the strong form for situations
  where a single attempt is required.

---

## 14. Miscellaneous (MSC)

### MSC30-C — Do not use the rand() function for generating pseudorandom numbers

- `rand()` provides insufficient randomness and is not suitable for
  security-sensitive purposes.
- Use a cryptographically secure random source (e.g., `getrandom`,
  `/dev/urandom`, platform CSPRNG APIs) for security purposes, or a
  higher-quality PRNG for simulation.

### MSC32-C — Properly seed pseudorandom number generators

- Always seed the PRNG before use.
- Do not use a constant seed in production code.
- Use an unpredictable source (current time combined with PID, or a system
  entropy source) for the seed.

### MSC33-C — Do not pass invalid data to the asctime() function

- `asctime` and `asctime_r` have restrictions on the range of `tm` struct
  fields.
- Validate `tm` contents before passing, or prefer `strftime` which does not
  have these limitations.

### MSC37-C — Ensure that control never reaches the end of a non-void function

- A non-`void` function that falls off the end without a `return` statement
  produces undefined behavior when the caller uses the return value.
- Ensure every code path ends with an explicit `return`.
- Use `_Noreturn` for functions that do not return.

### MSC38-C — Do not treat a predefined identifier as an object if it might only be implemented as a macro

- Standard identifiers such as `assert`, `errno`, `setjmp`, and `va_arg` may be
  implemented as macros.
- Do not take the address of these identifiers or attempt to use them as
  function pointers.

### MSC39-C — Do not call va_arg() on a va_list that has an indeterminate value

- After `va_end`, the `va_list` is indeterminate.
- Do not call `va_arg` after `va_end` or on a `va_list` that has not been
  initialized with `va_start` or `va_copy`.
- Call `va_end` before returning from any function that called `va_start`.

### MSC40-C — Do not violate constraints

- The C standard defines constraints: conditions that must hold for a construct
  to have defined behavior.
- A constraint violation is diagnosed as a compile-time error by conforming
  compilers.
- Resolve all constraint violations; never suppress diagnostic messages that
  report them.

---

## Enforcement Checklist for AI Agents

When generating C code, verify each of the following before finalizing output:

- [ ] No macro arguments with side effects passed to unsafe macros (PRE31-C)
- [ ] No preprocessor directives inside macro invocations (PRE32-C)
- [ ] All variables initialized before first read (EXP33-C)
- [ ] All pointer dereferences guarded against null (EXP34-C)
- [ ] No type-punning through incompatible pointer casts (EXP39-C)
- [ ] All user-supplied format strings excluded from `printf`-family calls
      (FIO30-C)
- [ ] Signed integer arithmetic checked for overflow before each operation
      (INT32-C)
- [ ] Unsigned integer arithmetic checked for wrap before each operation
      (INT30-C)
- [ ] Divisor checked for zero before every `/` or `%` (INT33-C)
- [ ] Shift counts validated to be in `[0, width-1]` (INT34-C)
- [ ] All `malloc`/`calloc`/`realloc` return values checked (EXP34-C, ERR33-C)
- [ ] All allocated memory freed on every code path (MEM31-C)
- [ ] No pointer used after `free` (MEM30-C)
- [ ] String buffers sized with room for null terminator (STR31-C)
- [ ] Strings null-terminated before passing to library functions (STR32-C)
- [ ] All opened files closed on every code path (FIO42-C)
- [ ] Signal handlers use only async-signal-safe operations (SIG30-C)
- [ ] Mutex locking order consistent to avoid deadlock (CON35-C)
- [ ] Condition variable waits wrapped in `while` loops (CON36-C)
- [ ] `errno` set to zero before calls that set it; checked only after error
      return (ERR30-C)
- [ ] All non-`void` functions end with an explicit `return` on every path
      (MSC37-C)
- [ ] `va_end` called before returning from variadic functions (MSC39-C)
