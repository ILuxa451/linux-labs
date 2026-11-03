#!/bin/bash
THRESHOLD=90
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "WARNING: Disk usage is at ${USAGE}%" | mail -s "Disk Alert on $(hostname)" admin@company.local
fi
