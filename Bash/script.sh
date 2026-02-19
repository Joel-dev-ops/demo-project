#!/usr/bin/env bash                      # Use env to find bash in PATH
set -euo pipefail                        # Strict mode: exit on error, undefined var, pipe failures
IFS=$'\n\t'                              # Safer word splitting

readonly SCRIPT_NAME=$(basename "$0")    # Get script name
readonly LOCK_FILE="/tmp/${SCRIPT_NAME}.lock"   # Lock file path
readonly LOG_FILE="/tmp/${SCRIPT_NAME}.log"     # Log file path

########################################
# Logging function
########################################
log() {
  local level="$1"                       # First argument = log level
  shift                                  # Shift arguments left
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOG_FILE"
}

########################################
# Cleanup function
########################################
cleanup() {
  log INFO "Cleaning up resources..."    # Log cleanup action
  [[ -f "$TMP_FILE" ]] && rm -f "$TMP_FILE"   # Remove temp file if exists
}
trap cleanup EXIT                        # Run cleanup on exit
trap 'log ERROR "Error on line $LINENO"' ERR   # Log line number on error

########################################
# Retry function
########################################
retry() {
  local retries=5                        # Number of retries
  local count=0                          # Counter

  until "$@"; do                         # Run command passed as arguments
    exit_code=$?                         # Capture exit code
    count=$((count+1))                   # Increment counter

    if [[ $count -ge $retries ]]; then
      log ERROR "Command failed after $retries attempts."
      return "$exit_code"                # Return last exit code
    fi

    log WARN "Retrying ($count/$retries)..."
    sleep 2                              # Wait before retry
  done
}

########################################
# Argument parsing
########################################
ENV="dev"                                # Default environment
VERBOSE=false                            # Default verbose mode

while getopts ":e:v" opt; do              # Parse flags
  case ${opt} in
    e ) ENV=$OPTARG ;;                   # -e value sets ENV
    v ) VERBOSE=true ;;                  # -v enables verbose
    \? ) echo "Invalid option"; exit 1 ;;
  esac
done

########################################
# Enable debug if verbose
########################################
if [[ "$VERBOSE" == true ]]; then
  set -x                                  # Enable debug mode
fi

########################################
# Acquire lock (prevent parallel runs)
########################################
exec 200>"$LOCK_FILE"                    # Open FD 200 for lock file
flock -n 200 || {                        # Try to acquire lock
  log ERROR "Another instance is running."
  exit 1
}

########################################
# Create temp file safely
########################################
TMP_FILE=$(mktemp)                       # Create secure temp file
log INFO "Using temp file: $TMP_FILE"

########################################
# Example array usage
########################################
services=("nginx" "docker")              # Array of services

########################################
# Idempotent service check
########################################
check_and_start_service() {
  local service="$1"

  if ! systemctl is-active --quiet "$service"; then
    log INFO "Starting $service..."
    retry systemctl start "$service"     # Retry service start
  else
    log INFO "$service already running."
  fi
}

########################################
# Background task example
########################################
background_task() {
  sleep 3                                 # Simulate long task
  echo "Background task done" > "$TMP_FILE"
}

########################################
# JSON parsing example
########################################
parse_json_example() {
  echo '{"app":"demo","version":"1.0"}' > "$TMP_FILE"
  app_name=$(jq -r '.app' "$TMP_FILE")    # Extract JSON field
  log INFO "Parsed app name: $app_name"
}

########################################
# Safe file reading
########################################
read_file_safely() {
  while IFS= read -r line; do             # Prevent backslash escaping
    log INFO "Line: $line"
  done < "$TMP_FILE"
}

########################################
# Main function
########################################
main() {

  log INFO "Starting script in $ENV environment."

  # Loop through services safely
  for svc in "${services[@]}"; do
    check_and_start_service "$svc"
  done

  # Run background process
  background_task &                      # Run in background
  bg_pid=$!                              # Capture PID
  wait "$bg_pid"                         # Wait for completion

  # JSON parsing
  parse_json_example

  # Read temp file safely
  read_file_safely

  log INFO "Script completed successfully."
}

########################################
# Execute main
########################################
main "$@"
