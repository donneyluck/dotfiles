#!/bin/bash
# cpu.sh - show CPU usage (matching conky: cpu ${cpu cpu0}%)
# Use top for a more accurate instantaneous CPU percentage

CPU=$(top -l 1 | grep "CPU usage" | awk '{print int($3)}')
echo "${CPU}%"
