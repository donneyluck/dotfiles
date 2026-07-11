#!/bin/bash
# cpu.sh - total CPU usage = user + sys (matches conky ${cpu cpu0}%)
top -l 1 | grep "CPU usage" | awk '{printf "%.0f%%", $3 + $5}'
