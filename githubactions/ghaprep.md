# Workflow name (visible in GitHub UI)
name: Complete CI/CD Workflow Example

# Trigger conditions
on:
  push:                     # Runs on push events
    branches: [main, develop]
  pull_request:             # Runs on PRs
  workflow_dispatch:        # Manual trigger from UI
  schedule:                 # Cron-based trigger
    - cron: "0 0 * * *"     # Runs daily at midnight

# Global environment variables
env:
  GLOBAL_VAR: "Hello_CI"

# Default settings for all run steps
defaults:
  run:
    shell: bash
    working-directory: .

# Prevent duplicate workflow runs
concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:

  # ---------------- BUILD JOB ----------------
  build:
    name: Build Job

    # Runner selection (GitHub-hosted or self-hosted)
    runs-on: ubuntu-latest

    # Timeout for job
    timeout-minutes: 30

    # Permissions (security best practice)
    permissions:
      contents: read

    # Environment (for deployment protection rules)
    environment: dev

    # Conditional execution
    if: github.ref == 'refs/heads/main'

    # Strategy for matrix builds
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest]
        compiler: [gcc, clang]

    # Job-level environment variables
    env:
      JOB_VAR: "Build_Stage"

    # Outputs to pass to other jobs
    outputs:
      build_version: ${{ steps.set_output.outputs.version }}

    steps:
      # Step 1: Checkout repo
      - name: Checkout Code
        uses: actions/checkout@v4   # uses keyword → prebuilt action

      # Step 2: Cache dependencies
      - name: Cache Dependencies
        uses: actions/cache@v3
        with:
          path: ~/.cache
          key: ${{ runner.os }}-${{ hashFiles('**/lockfile') }}

      # Step 3: Run shell command
      - name: Build Application
        run: |
          echo "Building with ${{ matrix.compiler }}"
          mkdir build && cd build
          cmake ..
          make

      # Step 4: Step-level environment variables
      - name: Run Tests
        env:
          TEST_ENV: "test"
        run: |
          echo "Running tests in $TEST_ENV"
          ctest || true   # continue-on-error alternative

      # Step 5: Set output
      - name: Set Output
        id: set_output
        run: |
          echo "version=1.0.${{ github.run_number }}" >> $GITHUB_OUTPUT

      # Step 6: Upload artifact
      - name: Upload Artifact
        uses: actions/upload-artifact@v4
        with:
          name: build-artifact
          path: build/

  # ---------------- TEST JOB ----------------
  test:
    name: Test Job

    runs-on: ubuntu-latest

    # Dependency on build job
    needs: build

    steps:
      - name: Download Artifact
        uses: actions/download-artifact@v4
        with:
          name: build-artifact

      - name: Run Integration Tests
        run: echo "Testing build version ${{ needs.build.outputs.build_version }}"

  # ---------------- DEPLOY JOB ----------------
  deploy:
    name: Deploy Job

    runs-on: ubuntu-latest

    needs: test

    # Only deploy on main branch
    if: github.ref == 'refs/heads/main'

    environment: production

    steps:
      - name: Deploy Application
        run: echo "Deploying to production..."

      # Example of using secrets securely
      - name: Use Secret
        env:
          API_KEY: ${{ secrets.API_KEY }}
        run: echo "Using secret safely"

  # ---------------- CONTAINER JOB ----------------
  container-job:
    name: Run in Container

    runs-on: ubuntu-latest

    # Run job inside Docker container
    container:
      image: ubuntu:22.04

    # Dependent services (e.g., DB for testing)
    services:
      redis:
        image: redis
        ports:
          - 6379:6379

    steps:
      - name: Run Inside Container
        run: echo "Running inside container with Redis service"


  Interviewers often ask:

👉 “Which keywords do you use most?”

Answer:

Core → on, jobs, runs-on, steps, uses, run
Flow → needs, if, strategy
Security → secrets, permissions
Optimization → cache, artifacts, concurrency
