#!/usr/bin/env bash
set -euo pipefail

dbg() {
  printf '[extract-loxconfig] %s\n' "$*" >&2
}

html="$(cat)"

html_one_line="$(printf '%s' "$html" | tr '\n' ' ')"

b64="$(printf '%s' "$html_one_line" \
  | grep -oP '<div[^>]*class="[^"]*\bloxone-software-download-root\b[^"]*"[^>]*data-config="\K[^"]+' \
  | head -n 1 || true)"

if [ -z "$b64" ]; then
  dbg "ERROR: b64 empty"
  exit 1
fi

decoded="$(printf '%s' "$b64" | base64 -d 2>/dev/null || true)"

if [ -z "$decoded" ]; then
  dbg "ERROR: decoded empty"
  exit 1
fi

match_line="$(printf '%s\n' "$decoded" \
  | grep -o '"label":"Download","url":"[^"]*"' \
  | head -n 1 || true)"

if [ -z "$match_line" ]; then
  dbg "ERROR: match_line empty"
  dbg "decoded grep fallback preview:"
  printf '%s\n' "$decoded" | grep 'Download' >&2 || true
  exit 1
fi

url="$(printf '%s\n' "$match_line" \
  | sed 's/^.*"url":"//; s/"$//; s#\\/#/#g')"

if [ -z "$url" ]; then
  dbg "ERROR: url empty"
  exit 1
fi

printf '%s\n' "$url"
