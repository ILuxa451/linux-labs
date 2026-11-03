#!/bin/bash
# Скрипт очистки старых логов (старше 7 дней)
find /var/log -type f -name "*.log" -mtime +7 -delete
