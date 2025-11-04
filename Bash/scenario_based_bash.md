Scenario-Based Linux & Bash Questions
1. Cleaning up old log files

Scenario:
Your application generates log files daily in /var/log/myapp/. You need a script to delete log files older than 7 days automatically.

Question:
Write a Bash script to accomplish this.

Answer:

#!/bin/bash

LOG_DIR="/var/log/myapp"
DAYS=7

if [ -d "$LOG_DIR" ]; then
    find "$LOG_DIR" -type f -name "*.log" -mtime +$DAYS -exec rm -f {} \;
    echo "Deleted logs older than $DAYS days from $LOG_DIR"
else
    echo "Directory $LOG_DIR does not exist."
fi


Explanation:

find ... -mtime +7 → finds files modified more than 7 days ago.

-exec rm -f {} → deletes them safely.

Checking if the directory exists avoids errors.

2. Monitoring disk usage and sending alert

Scenario:
You need a script that checks if any disk partition exceeds 80% usage, and if so, prints a warning.

Question:
Write a Bash one-liner or script for this.

Answer:

#!/bin/bash

THRESHOLD=80

df -h | awk 'NR>1 {gsub("%","",$5); if($5>'"$THRESHOLD"') print "Warning: Partition "$6" usage is "$5"%"}'


Explanation:

df -h lists disk usage.

awk removes % and compares usage.

NR>1 skips the header.

3. Creating a timestamped backup

Scenario:
You need to backup /etc directory daily with a timestamped filename, keeping only the last 5 backups.

Question:
Write a Bash script for this.

Answer:

#!/bin/bash

SRC="/etc"
DEST="/backup"
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
BACKUP_FILE="$DEST/etc_backup_$TIMESTAMP.tar.gz"

mkdir -p "$DEST"
tar -czf "$BACKUP_FILE" "$SRC"
echo "Backup created: $BACKUP_FILE"

# Keep only last 5 backups
ls -tp $DEST/etc_backup_*.tar.gz | tail -n +6 | xargs -I {} rm -- {}


Explanation:

ls -tp → lists files with newest first.

tail -n +6 → selects everything older than the 5 most recent.

xargs rm → deletes old backups.

4. Checking if a service is running and restarting if not

Scenario:
Your critical service nginx must always run. You need a Bash script to check its status and restart it if it’s down.

Question:
Write a script to automate this.

Answer:

#!/bin/bash

SERVICE="nginx"

if systemctl is-active --quiet "$SERVICE"; then
    echo "$SERVICE is running."
else
    echo "$SERVICE is not running. Restarting..."
    systemctl restart "$SERVICE"
    if systemctl is-active --quiet "$SERVICE"; then
        echo "$SERVICE restarted successfully."
    else
        echo "Failed to restart $SERVICE."
    fi
fi


Explanation:

systemctl is-active --quiet returns success if the service is running.

systemctl restart safely restarts the service.

5. Parsing log files to count errors

Scenario:
Your application writes logs in /var/log/myapp/app.log. You want to count the number of ERROR and WARNING messages in the last 24 hours.

Question:
Write a Bash command or script for this.

Answer:

#!/bin/bash

LOG_FILE="/var/log/myapp/app.log"

echo "Errors in last 24 hours:"
grep "$(date --date='1 day ago' '+%Y-%m-%d')" "$LOG_FILE" | grep -c "ERROR"

echo "Warnings in last 24 hours:"
grep "$(date --date='1 day ago' '+%Y-%m-%d')" "$LOG_FILE" | grep -c "WARNING"


Explanation:

grep with date filters logs from last 24 hours.

grep -c counts occurrences.

6. Script to check multiple servers via SSH

Scenario:
You have multiple servers in a list (servers.txt). You want to check disk usage on all of them and print a report.

Question:
Write a Bash snippet for this.

Answer:

#!/bin/bash

while read -r server; do
    echo "Checking disk usage on $server..."
    ssh "$server" "df -h | awk 'NR>1 {print \$1, \$5, \$6}'"
done < servers.txt


Explanation:

Loops through servers.txt.

Uses ssh to execute df -h remotely.

Escaping $ in awk is necessary in double quotes.

Scenario-Based Linux & Bash Questions for DevOps (4 yrs Exp)
1. Cleaning up old log files

Scenario:
Your application generates log files daily in /var/log/myapp/. You need a script to delete log files older than 7 days automatically.

Answer:

#!/bin/bash
LOG_DIR="/var/log/myapp"
DAYS=7

if [ -d "$LOG_DIR" ]; then
    find "$LOG_DIR" -type f -name "*.log" -mtime +$DAYS -exec rm -f {} \;
    echo "Deleted logs older than $DAYS days from $LOG_DIR"
else
    echo "Directory $LOG_DIR does not exist."
fi


Explanation: Uses find with -mtime to delete old logs safely.

2. Monitoring disk usage and sending alerts

Scenario:
Check if any disk partition exceeds 80% usage and alert.

Answer:

#!/bin/bash
THRESHOLD=80
df -h | awk 'NR>1 {gsub("%","",$5); if($5>'"$THRESHOLD"') print "Warning: Partition "$6" usage is "$5"%"}'


Explanation: Parses df output, skips header, and alerts for usage > 80%.

3. Timestamped backups with retention

Scenario:
Backup /etc daily, keeping only the last 5 backups.

Answer:

#!/bin/bash
SRC="/etc"
DEST="/backup"
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
BACKUP_FILE="$DEST/etc_backup_$TIMESTAMP.tar.gz"

mkdir -p "$DEST"
tar -czf "$BACKUP_FILE" "$SRC"

ls -tp $DEST/etc_backup_*.tar.gz | tail -n +6 | xargs -I {} rm -- {}


Explanation: Uses ls -tp and tail -n +6 to keep the 5 newest backups.

4. Checking and restarting a service

Scenario:
Ensure nginx is always running.

Answer:

#!/bin/bash
SERVICE="nginx"

if systemctl is-active --quiet "$SERVICE"; then
    echo "$SERVICE is running."
else
    systemctl restart "$SERVICE"
    echo "$SERVICE restarted."
fi


Explanation: Uses systemctl is-active to check and restart if needed.

5. Parsing logs for errors

Scenario:
Count ERROR and WARNING in /var/log/myapp/app.log from the last 24 hours.

Answer:

#!/bin/bash
LOG_FILE="/var/log/myapp/app.log"

echo "Errors:"
grep "$(date --date='1 day ago' '+%Y-%m-%d')" "$LOG_FILE" | grep -c "ERROR"

echo "Warnings:"
grep "$(date --date='1 day ago' '+%Y-%m-%d')" "$LOG_FILE" | grep -c "WARNING"


Explanation: Combines date and grep to filter last 24h logs.

6. Checking multiple servers via SSH

Scenario:
Check disk usage on servers listed in servers.txt.

Answer:

#!/bin/bash
while read -r server; do
    echo "Disk usage on $server:"
    ssh "$server" "df -h | awk 'NR>1 {print \$1, \$5, \$6}'"
done < servers.txt


Explanation: Loops through servers, runs remote commands via SSH.

7. Cron job to run script daily

Scenario:
Automate /opt/scripts/cleanup.sh to run every day at 2 AM.

Answer:

0 2 * * * /opt/scripts/cleanup.sh >> /var/log/cleanup.log 2>&1


Explanation: Cron format: minute hour day month weekday command.

8. Script to check CPU load

Scenario:
Alert if CPU load exceeds 80%.

Answer:

#!/bin/bash
CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)
THRESHOLD=0.8

CPU_NUM=$(nproc)
LOAD_PERCENT=$(echo "$CPU_LOAD/$CPU_NUM" | bc -l)

if (( $(echo "$LOAD_PERCENT > $THRESHOLD" | bc -l) )); then
    echo "High CPU load: $CPU_LOAD"
fi


Explanation: Normalizes load by CPU cores and alerts.

9. Check and create directory if missing

Scenario:
Ensure /opt/data exists before a script runs.

Answer:

#!/bin/bash
DIR="/opt/data"
mkdir -p "$DIR"


Explanation: mkdir -p creates directory if it doesn’t exist, no error if already exists.

10. Sync files using rsync

Scenario:
Sync /var/www/html to /backup/html efficiently.

Answer:

rsync -av --delete /var/www/html/ /backup/html/


Explanation: -a preserves attributes, --delete removes old files.

11. Archive and compress logs older than 30 days

Scenario:
Archive /var/log/myapp/*.log older than 30 days.

Answer:

find /var/log/myapp -type f -name "*.log" -mtime +30 -exec tar -rvf /backup/old_logs.tar {} \; -exec rm -f {} \;


Explanation: Archives old logs, then deletes originals.

12. Extract lines matching pattern from compressed logs

Scenario:
Search ERROR in /var/log/myapp/app.log.gz.

Answer:

zgrep "ERROR" /var/log/myapp/app.log.gz


Explanation: zgrep works directly on .gz files.

13. Replace text in multiple files using sed

Scenario:
Replace DEBUG with INFO in all .conf files.

Answer:

sed -i 's/DEBUG/INFO/g' /etc/myapp/*.conf


Explanation: -i edits files in-place, g for global replacement.


14. Check open ports and services

Scenario:
Verify if port 8080 is listening.

Answer:

#!/bin/bash
PORT=8080
if ss -tuln | grep -q ":$PORT "; then
    echo "Port $PORT is listening"
else
    echo "Port $PORT is not open"
fi


Explanation: Uses ss to check TCP/UDP ports.

15. Wait for a service to start

Scenario:
Wait up to 60 seconds for mysql to start.

Answer:

#!/bin/bash
TIMEOUT=60
while ! systemctl is-active --quiet mysql && [ $TIMEOUT -gt 0 ]; do
    sleep 1
    TIMEOUT=$((TIMEOUT-1))
done

if systemctl is-active --quiet mysql; then
    echo "MySQL is running"
else
    echo "MySQL failed to start"
fi


Explanation: Polls service with timeout.

16. Monitor a log file in real-time

Scenario:
Tail /var/log/myapp/app.log and filter only ERROR.

Answer:

tail -f /var/log/myapp/app.log | grep --line-buffered "ERROR"


Explanation: --line-buffered ensures live output.

17. Check disk inode usage

Scenario:
Warn if inode usage > 90%.

Answer:

#!/bin/bash
df -i | awk 'NR>1 {gsub("%","",$5); if($5>90) print "High inode usage on "$6": "$5"%"}'


Explanation: df -i shows inodes; awk filters high usage.

18. Script to rotate logs manually

Scenario:
Rotate /var/log/myapp/app.log daily with timestamp.

Answer:

#!/bin/bash
LOG="/var/log/myapp/app.log"
mv "$LOG" "$LOG.$(date +%Y%m%d)"
touch "$LOG"


Explanation: Moves log and creates a new one.

19. Compare two directories

Scenario:
Compare /var/www/html and /backup/html.

Answer:

diff -qr /var/www/html /backup/html


Explanation: -q reports only differences, -r recursive.

20. Check memory usage and alert

Scenario:
Alert if free memory < 500MB.

Answer:

#!/bin/bash
FREE_MEM=$(free -m | awk '/^Mem:/ {print $4}')
if [ "$FREE_MEM" -lt 500 ]; then
    echo "Low memory: ${FREE_MEM}MB available"
fi


Explanation: Uses free -m and awk to check memory.

21. Bash script with argument parsing

Scenario:
Script accepts --start or --stop to manage a service.

Answer:

#!/bin/bash
SERVICE="nginx"
case "$1" in
    --start)
        systemctl start "$SERVICE"
        ;;
    --stop)
        systemctl stop "$SERVICE"
        ;;
    *)
        echo "Usage: $0 --start|--stop"
        ;;
esac


Explanation: Simple argument handling using case.

22. Find and kill process by name

Scenario:
Kill any runaway myapp process consuming high CPU.

Answer:

#!/bin/bash
PIDS=$(pgrep myapp)
if [ -n "$PIDS" ]; then
    echo "Killing processes: $PIDS"
    kill -9 $PIDS
fi


Explanation: pgrep finds PIDs; kill -9 terminates them.
