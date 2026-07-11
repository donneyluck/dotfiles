#!/bin/bash
# cpu.sh - show CPU usage

TOP=$(ps aux | awk 'NR>1 {sum += $3} END {printf "%.0f%%", sum/NR}')
echo "$TOP"
