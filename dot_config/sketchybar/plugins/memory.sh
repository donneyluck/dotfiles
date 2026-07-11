#!/bin/bash
# memory.sh - show memory usage (matching conky:  memperc% U: mem F: memfree)
# Parse: top -l 1 -s 0 | grep PhysMem
# Example: "PhysMem: 15G used (2487M wired, 0B compressor), 1221M unused."

LINE=$(top -l 1 -s 0 | grep PhysMem)

# Convert "15G" or "1221M" to MB
to_mb() {
  local raw="$1"
  local val=$(echo "$raw" | sed 's/[GM]//g')
  local unit=$(echo "$raw" | sed 's/[0-9]//g')
  if [ "$unit" = "G" ]; then
    echo $((val * 1024))
  else
    echo "$val"
  fi
}

# First number+unit after ":" = used (sed, no -P)
USED_RAW=$(echo "$LINE" | sed -n 's/^[^:]*:[[:space:]]*\([0-9]*[GM]\) used.*/\1/p')
# Last number+unit before "unused" = free
FREE_RAW=$(echo "$LINE" | sed -n 's/.*[^0-9]\([0-9]*[GM]\) unused.*/\1/p')

USED=$(to_mb "$USED_RAW")
FREE=$(to_mb "$FREE_RAW")
TOTAL=$((USED + FREE))

if [ "$TOTAL" -gt 0 ]; then
  PERC=$((USED * 100 / TOTAL))
else
  PERC=0
fi

echo "${PERC}% (U:${USED}MB F:${FREE}MB)"
