#!/bin/bash

PROCESS_NAME="test"
API_URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"
TEMP_PID_FILE="/tmp/test_process_pid"

PROCESS_PID=$(pgrep -x "$PROCESS_NAME")

if [ -z "$PROCESS_PID" ]; then
    exit 0
fi

if [ -f "$TEMP_PID_FILE" ]; then
    OLD_PID=$(cat "$TEMP_PID_FILE")
    if [ "$OLD_PID" != "$PROCESS_PID" ]; then
        echo "$(date) - Процесс $PROCESS_NAME был перезапущен. Новый PID: $PROCESS_PID" >> "$LOG_FILE"
    fi
else
    echo "$PROCESS_PID" > "$TEMP_PID_FILE"
fi

curl --silent --fail --insecure "$API_URL" || {
    echo "$(date) - Ошибка подключения к серверу мониторинга $API_URL" >> "$LOG_FILE"
}
