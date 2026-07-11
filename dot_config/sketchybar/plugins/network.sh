#!/bin/bash
# network.sh - show public IP + local network info (matching conky output)
# conky:   wlan: ${exec curl icanhazip.com}    eth: ${addr ens33}

# Public IP (with timeout to avoid hanging)
PUBIP=$(curl -s --max-time 3 icanhazip.com 2>/dev/null)
[ -z "$PUBIP" ] && PUBIP="N/A"

# Local IP (WiFi/en0 first, fallback to en1)
LOCALIP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)
[ -z "$LOCALIP" ] && LOCALIP="N/A"

echo "  pub:${PUBIP}  loc:${LOCALIP}"
