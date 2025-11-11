1. CI/CD (Jenkins, GitLab CI, Build Systems)
Q1. Explain the difference between Declarative and Scripted Jenkins pipelines.

Answer:

Declarative Pipeline: Structured syntax, easier to read/maintain, built-in stages (stages {}), designed for common use cases.

Scripted Pipeline: Full Groovy code, more flexible, allows complex logic, better for dynamic/custom pipelines.
Use Case: Declarative for standard CI/CD flows; Scripted when pipeline logic depends on dynamic conditions or custom integrations.

Q2. How would you design a Jenkins pipeline to build and test LLVM across multiple architectures?

Answer:

Use multibranch pipeline to handle multiple branches.

Use matrix or parallel stages to build on different architectures.

Stage structure:

Checkout code

Configure build environment

Build (CMake/Ninja)

Run unit tests

Archive artifacts

Notify results (Slack/Email)

Optionally use Docker agents to isolate builds per architecture.

Q3. How do you cache build artifacts to reduce CI runtime?

Answer:

Store intermediate build outputs in a shared cache (e.g., S3, NFS, or Jenkins artifact store).

Use CMake’s build directory caching.

Only rebuild changed modules.

Configure Docker layer caching if building containerized environments.

2. Scripting / Automation (Python, Bash, Groovy)
Q4. Write a Python script to parse a build log and report modules that failed.
failed_modules = []
with open("build.log") as f:
    for line in f:
        if "error:" in line.lower():
            module = line.split(":")[0]
            failed_modules.append(module)
print("Failed Modules:", set(failed_modules))


Explanation: Loops through log lines, looks for “error:”, extracts module name, reports unique failures.

Q5. Bash script to check disk usage and remove logs older than 7 days
#!/bin/bash
LOG_DIR="/var/build_logs"
THRESHOLD=80
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$USAGE" -gt "$THRESHOLD" ]; then
  find "$LOG_DIR" -type f -mtime +7 -exec rm -f {} \;
  echo "Old logs deleted."
fi


Explanation: Checks disk usage, deletes logs older than 7 days if threshold exceeded.

3. Linux Debugging / System Administration
Q6. A Jenkins agent hangs during a build. How do you debug?

Answer:

SSH into the agent, run top or htop to check CPU/memory usage.

Use ps -ef or pstree to find stuck processes.

Check build logs in Jenkins.

Use strace -p <pid> to trace system calls.

Verify disk space (df -h) and inode usage.

Check network connectivity if build pulls dependencies.

Q7. How do you handle zombie processes?

Answer:

Zombie processes are defunct child processes whose parent didn’t read their exit status.

Identify with ps aux | grep Z.

Kill the parent process or restart the service that created them.

4. Containers & Kubernetes
Q8. How would you containerize an LLVM build environment?

Answer:

Use a base image (Ubuntu/Fedora) with essential dependencies.

Install CMake, Ninja, Python, compilers.

Set volume mounts for source and build directories.

Cache build directories to speed up repeated builds.

Example Dockerfile snippet:

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y cmake ninja-build python3 g++
WORKDIR /workspace

Q9. Difference between Kubernetes Deployments and DaemonSets

Answer:

Deployment: Manages replicas of pods, good for stateless apps.

DaemonSet: Ensures a pod runs on every node (good for monitoring/logging agents).

Q10. How would you share build artifacts between pods?

Answer:

Use PersistentVolume (PV) + PersistentVolumeClaim (PVC).

Mount the volume in all pods.

Alternatively, use object storage (S3, GCS) and download/upload artifacts during pipeline execution.

5. Build Systems / Compiler Context
Q11. Key stages of an LLVM build process

Answer:

Checkout LLVM source code.

Configure build with CMake, specifying target architectures.

Compile with Ninja or make.

Run unit and regression tests.

Package binaries/artifacts for deployment.

Q12. How can you reduce incremental build times?

Answer:

Use out-of-source builds to avoid cleaning unrelated files.

Enable caching for unchanged modules.

Parallelize builds with -jN (N = number of cores).

Use ccache to cache compiler outputs.

Q13. Familiarity with Git/Gerrit

Support branching strategies (feature, release, main).

Handle code reviews via Gerrit.

Example Q: “How do you cherry-pick a commit across branches?”
Answer:

git checkout target-branch
git cherry-pick <commit-hash>

6. Behavioral / Collaboration Questions
Q14. Tell me about a time you automated a complex workflow.

Model Answer:

Situation: Our CI build took 4 hours for LLVM.

Task: Reduce build time and manual intervention.

Action: Wrote a Python automation script + Jenkins parallel pipeline, added caching.

Result: Reduced build time to 1.5 hours, reduced developer wait time, documented process for team.

Q15. How do you collaborate with engineers to fix build issues?

Answer:

Communicate clearly, reproduce the issue locally.

Suggest fixes without altering code logic.

Update CI configuration and documentation.

Conduct post-mortems to prevent recurrence.

Q16. How do you handle production build failures?

Answer:

Triage severity: determine affected modules/services.

Use logs, strace, and system monitoring to find root cause.

Roll back to previous stable build if necessary.

Communicate with stakeholders and implement preventive measures.

✅ Summary of Key Preparation Areas

CI/CD: Jenkins, GitLab CI, build pipeline design.

Scripting: Python, Bash, Groovy for automation.

Linux: Debugging, system monitoring, process management.

Containers/Kubernetes: Dockerfile optimization, pods, volumes.

Build Systems: CMake, Ninja, LLVM/GCC basics.

Collaboration & Behavioral: STAR format, documenting and improving workflows.
