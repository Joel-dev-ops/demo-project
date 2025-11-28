Answers to All 40 Shell Scripting Interview Questions
1. Core Shell Scripting & Linux Expertise
1. Difference between sh, bash, dash, and ksh.

sh – POSIX shell; minimal features; maximum portability.

bash – GNU shell; rich features (arrays, [[ ]], brace expansion). Default in many distros.

dash – Lightweight POSIX shell; very fast; used for /bin/sh in Debian/Ubuntu.

ksh – KornShell; enterprise UNIX (AIX/Solaris); strong for scripting.

When choosing:

CI/CD, system scripts → dash/sh for portability.

Automation, dev scripts → bash for features.

Legacy enterprise UNIX → ksh.

2. Variable scope and exporting.

Local variables: local to the shell function (local var=value in bash).

Global: visible within the same shell instance.

Exported: added to the environment → available to child processes.

Export in a subshell does NOT affect the parent, because environment flows down, not up.

3. Meaning of set -euo pipefail.

-e exit on error

-u treat undefined variables as errors

-o pipefail pipeline fails if any part fails

Used for: production-grade, safer scripts (CI/CD, deployment).

4. Piping vs redirection.

Pipe (|) chains stdout of one command into stdin of next, creating subshells.

> overwrite file.

>> append.

2>&1 merge stderr into stdout.

Pipe splits execution across processes; redirect doesn’t.

5. Detect interactive vs non-interactive shell.

Check:

[[ $- == *i* ]]


or:

Interactive shells have a tty: tty -s

$PS1 is set only interactively.

2. Troubleshooting & Debugging
6. Debugging a shell script (set -x, PS4).

set -x prints every executed command.

PS4='+$BASH_SOURCE:$LINENO:' prefixes traces with file/line numbers.

7. Profiling a slow script.

Methods:

Add timestamps around blocks.

Use strace/dtruss.

Use bash -x trace analysis.

Measure loops by counting iterations/time.

8. Finding which part failed in CI logs.

Use set -e + meaningful functions.

Always log entry/exit of functions.

Print $LINENO in traps.

Wrap critical commands with || { echo "...failed at line $LINENO"; exit 1; }.

3. Process Management & Parallel Execution
9. Running tasks in parallel.

Background processes:

cmd1 & cmd2 & wait


wait → synchronize.

xargs -P 4 → parallel execution.

GNU parallel → best for large workloads.

10. Race conditions and preventing with flock.

Race condition example: writing to same log file.
Solution:

flock /tmp/lockfile command


or atomic moves (mv) and temp files.

4. File Parsing & Data Transformation
11. AWK vs SED vs grep.

grep – search lines by pattern.

sed – line editing/transforming.

awk – field-based processing, arithmetic, logic → best for structured data.

12. Extracting Nth column in CSV with escaped commas.

Simple CSV:

cut -d, -f3


Proper CSV: use awk -F, only if no quotes.
For real CSV:

csvtool col 3 file.csv


or use Python/mlr.

13. Parse JSON in POSIX shell.

Use jq:

jq -r '.items[0].name' file.json


Without jq → very limited (not recommended); use grep/sed only for trivial JSON.

5. CI/CD & Automation
14. Validate environment variables / executables.
: "${VAR:?VAR not set}"
command -v git >/dev/null || { echo "git missing"; exit 1; }

15. Making scripts idempotent.

Check before creating/removing items.

Use mkdir -p, rm -f, cp -n.

Use state files or version checks.

Atomic operations.

16. Handling secrets in CI.

Use environment variable masking.

Never echo secrets.

Use set +x around sensitive areas.

Use secret managers (Vault, AWS Secrets Manager).

17. Safe abort during deployment.

Use traps:

trap cleanup EXIT INT TERM


Keep backups.

Use temporary staging directories.

Rollback on error.

6. Integrating Multiple Systems
18. Detect remote command success via SSH.

Always use:

ssh host "cmd"; echo $?


Pitfalls:

Remote .bashrc printing text corrupts output.

Use ssh -o BatchMode=yes.

Quote commands correctly.

19. Handling partial success.

Track success of each component.

Summaries at end.

Use rollback if required.

Use a state file or manifest.

20. Designing rollback in deployments.

Keep previous build version.

Atomic symlink switching.

Make backups before modifying config.

Log every step for reversal.

7. Advanced Shell Features
21. Using traps for cleanup.

Example:

trap 'rm -f "$tmpfile"' EXIT SIGINT SIGTERM


Ensures cleanup even on crash/interrupt.

22. When to use substitution types.

$(cmd) – capture output.

<(cmd) – use output as file descriptor.

>(cmd) – feed input to command.

<<EOF – multi-line input.

<<< – single-line here-string.

23. Bash arrays vs POSIX sh.

Bash supports indexed & associative arrays:

arr=(a b c)


POSIX sh has no arrays, only strings → use workarounds.

24. Detect OS reliably.
. /etc/os-release
echo $ID $VERSION_ID


For kernel:

uname -s

25. [[ ]] vs [ ].

[[ ]] is bash/ksh-only; supports regex and safer quoting.

[ ] is POSIX; portable but more fragile.

8. Build Systems, Packaging & Integration
26. Shell wrappers for build tools.

Use:

Environment validation

Absolute paths

Exit codes

Logging

Params:

mvn -q -DskipTests package

27. Example of complex orchestrator script.

Key patterns:

Modular functions

Config-driven behavior

Trap-based cleanup

Parallel steps

Logging + error codes

Retry logic

28. Ensuring cross-platform compatibility.

Use POSIX tools only.

Avoid GNU extensions unless checked.

Normalize paths.

Test inside container that mirrors CI environment.

9. Git & Versioning
29. Get branch, commit, status.
git rev-parse --abbrev-ref HEAD
git rev-parse HEAD
git status --porcelain

30. Automating semantic version bumps.

Example:

IFS=. read major minor patch < version.txt
echo "$major.$minor.$((patch+1))" > version.txt

10. Security & Robustness
31. Why eval is dangerous.

Executes arbitrary code; vulnerable to injection.
Replace with:

Arrays

Case statements

Indirection ${!var}

Config maps

32. Sanitizing user input.

Always quote variables: "$var"

Validate against regex:

[[ $var =~ ^[a-zA-Z0-9_-]+$ ]] || exit 1

33. Command injection risks.

Bad:

rm -rf /home/$user


If $user="bob; rm -rf /" → catastrophe.
Prevent:

Whitelist

Quote

Avoid eval

34. Secure temp files.
tmp=$(mktemp) || exit 1


Avoid predictable names like /tmp/file$$.

11. Real-World Scenarios
35. Integrating inconsistent component directories.

Approach:

Canonical directory structure

Mapping rules

Validation script

Normalization step

Logging mismatches

Fail early if missing artifacts

36. Retry logic with backoff.
for i in 1 2 4 8 16; do
    mycmd && break
    sleep $i
done

37. Implement timeout wrapper in shell.
timeout 30s mycmd


If unavailable:

( mycmd & pid=$! ; sleep 30 ; kill "$pid" 2>/dev/null ) &

38. Validate config file.

Define schema

Parse line by line

Check required keys

Collect errors before printing

Produce summary at end

39. Detect/prevent infinite loops.

Add iteration counters

Add timeout

Use set -e inside loops

Detect no-progress situations

40. Best practices for enterprise scripts.

Use set -euo pipefail

Strict validation

Modular functions

Logging framework

Idempotency

Traps + cleanup

POSIX compliance

Linters (shellcheck)

Avoid global variables

Use "$var" everywhere
