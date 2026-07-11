#!/bin/bash
# network.sh - show network status（WiFi or Ethernet）

# Try WiFi first
SSID=$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/^.*: //' 2>/dev/null)
if [ -n "$SSID" ] && [ "$SSID" != "You are not associated with an AirPort network." ]; then
  echo "$SSID"
else
  # Fallback: show local IP
  IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)
  if [ -n "$IP" ]; then
    echo "$IP"
  else
    echo "N/A"
  fi
fi
