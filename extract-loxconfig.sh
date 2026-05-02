#!/usr/bin/env bash
set -euo pipefail

html="$(cat)"

b64="$(printf '%s' "$html" \
  | tr '\n' ' ' \
  | grep -oP '<div[^>]*class="[^"]*\bloxone-software-download-root\b[^"]*"[^>]*data-config="\K[^"]+' \
  | head -n 1)"

[ -n "$b64" ] || exit 1

decoded="$(printf '%s' "$b64" | base64 -d 2>/dev/null || true)"

[ -n "$decoded" ] || exit 1

printf '%s\n' "$decoded" \
  | grep -oP '"label":"Download","url":"\K[^"]+' \
  | sed 's#\\/#/#g' \
  | head -n 1
