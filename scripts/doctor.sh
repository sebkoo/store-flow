#!/bin/sh
# StoreFlow doctor: read-only checks. It never installs, changes or deletes anything.
# Usage: ./scripts/doctor.sh [phase] [web]    for example: ./scripts/doctor.sh 12, or ./scripts/doctor.sh 10 web

phase=$(printf '%s' "${1:-20}" | sed 's/[^0-9].*//; s/^0*//')
[ -z "$phase" ] && phase=0
missing=0
xcode_opt='' java_from=7
if [ "$2" = web ]; then xcode_opt=optional java_from=12; fi

# check NAME FROM_PHASE MIN_MAJOR COMMAND FIX [optional]
check() {
  name=$1 from=$2 min=$3 cmd=$4 fix=$5 opt=$6
  out=$(eval "$cmd" 2>/dev/null | head -n 1)
  if [ -n "$out" ]; then
    major=$(printf '%s' "$out" | grep -Eo '[0-9]+' | head -n 1)
    if [ "$min" -gt 0 ] && [ "${major:-0}" -lt "$min" ]; then
      mark='✗'; [ -n "$opt" ] && mark='·'
      printf '  %s %-15s %s — needs %s or newer: %s\n' "$mark" "$name" "$out" "$min" "$fix"
      [ "$from" -le "$phase" ] && [ -z "$opt" ] && missing=1
    else
      printf '  ✓ %-15s %s\n' "$name" "$out"
    fi
  elif [ "$from" -gt "$phase" ]; then
    printf '  · %-15s not needed yet (Phase %s)\n' "$name" "$from"
  elif [ -n "$opt" ]; then
    printf '  · %-15s optional — %s\n' "$name" "$fix"
  else
    printf '  ✗ %-15s missing — %s\n' "$name" "$fix"
    missing=1
  fi
}

android_sdk() {
  for dir in "$ANDROID_HOME" "$HOME/Library/Android/sdk"; do
    if [ -n "$dir" ] && [ -d "$dir" ]; then echo "$dir"; return; fi
  done
}

echo "StoreFlow doctor — checking what Phase $phase needs (read-only)"
echo
echo "Tools"
check node 1 22 'node --version' 'install the LTS from nodejs.org, then open a new terminal'
check npm 1 0 'npm --version' 'comes with Node.js'
check git 1 0 'git --version' 'run: xcode-select --install'
check code 1 0 'code --version' "VS Code → Command Palette → Shell Command: Install 'code' command in PATH" optional
check docker 4 0 'docker --version' 'Docker Desktop, or: brew install colima docker docker-compose'
check 'docker engine' 4 0 "docker info --format '{{.ServerVersion}}'" 'start Docker Desktop (or run: colima start)'
check compose 4 2 'docker compose version' 'Compose v2 comes with Docker Desktop; with Colima: brew install docker-compose'
check xcode 6 26 'xcodebuild -version' 'install Xcode from the App Store, then: sudo xcode-select -s /Applications/Xcode.app' $xcode_opt
check java "$java_from" 21 'java --version' 'brew install --cask temurin@21, then open a new terminal'
check 'android sdk' 7 0 'android_sdk' 'for the Android steps: install Android Studio and open it once' optional
check aws 19 2 'aws --version' 'brew install awscli'
check go 15 0 'go version' 'brew install go'
check rustc 17 0 'rustc --version' 'brew install rustup, then: rustup default stable'
check scala 18 0 'scala --version' 'brew install coursier/formulas/coursier && cs setup' optional
check cargo-lambda 19 0 'cargo lambda --version' 'brew install cargo-lambda/tap/cargo-lambda'
check lstk 19 0 'lstk --version' 'brew install localstack/tap/lstk' optional

echo
echo "Ports StoreFlow uses (fine when the listener is StoreFlow itself)"
for port in 5432 8000 9324 8787 3000 3001 8080 8090; do
  who=$(lsof -nP -iTCP:"$port" -sTCP:LISTEN 2>/dev/null | awk 'NR==2 {print $1 " (pid " $2 ")"}')
  if [ -n "$who" ]; then printf '  • %-5s in use by %s\n' "$port" "$who"; else printf '  • %-5s free\n' "$port"; fi
done

echo
echo "Machine"
disk=$(df -Pk "$HOME" 2>/dev/null | awk 'NR==2 {printf "%d", $4 / 1048576}')
printf '  • free disk   %s GB' "${disk:-?}"
if [ -n "$disk" ] && [ "$disk" -lt 30 ]; then printf ' — tight: Xcode, Android Studio and Docker images are large'; fi
echo
ram=$(sysctl -n hw.memsize 2>/dev/null | awk '{printf "%d", $1 / 1073741824}')
printf '  • macOS       %s\n' "$(sw_vers -productVersion 2>/dev/null)"
printf '  • memory      %s GB' "${ram:-?}"
if [ -n "$ram" ] && [ "$ram" -lt 16 ]; then printf ' — works; run fewer things at once (one simulator or emulator at a time)'; fi
echo
echo
if [ "$missing" -eq 0 ]; then
  echo "Ready for Phase $phase."
else
  echo "Fix the ✗ lines, open a new terminal, and run the doctor again."
fi
exit "$missing"