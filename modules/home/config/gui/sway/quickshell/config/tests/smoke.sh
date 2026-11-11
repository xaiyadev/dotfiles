#!/bin/sh
# Live checks against the running bar: external tools, IPC, service state, log errors.
# Usage: tests/smoke.sh   (the bar must be running)
cd "$(dirname "$0")/.." || exit 1
config=$(pwd)
fail=0
ok()  { printf '  ok    %s\n' "$1"; }
bad() { printf '  FAIL  %s\n' "$1"; fail=1; }
warn() { printf '  warn  %s\n' "$1"; }

echo "== tools"
for tool in brightnessctl tailscale tuned-adm fw-fanctrl pw-dump pw-play swaymsg pgrep wpctl; do
    command -v "$tool" >/dev/null && ok "$tool" || bad "$tool missing"
done
for app in pwvucontrol overskride nm-connection-editor gnome-calendar swaylock; do
    command -v "$app" >/dev/null && ok "$app (popup button)" || warn "$app missing (popup button won't work)"
done
ft=$(command -v framework_tool || echo "$HOME/.local/state/quickshell/framework-tool/bin/framework_tool")
if [ -x "$ft" ] && sudo -n "$ft" --privacy >/dev/null 2>&1; then ok "framework_tool via sudo -n"; else bad "framework_tool via sudo -n"; fi

echo "== ipc"
status=$(qs ipc -p "$config" call bar status 2>&1) || { bad "bar is not running ($status)"; exit 1; }
ok "bar status"
qs ipc -p "$config" call notifications count >/dev/null 2>&1 && ok "notifications ipc" || bad "notifications ipc"
qs ipc -p "$config" call gamemode status >/dev/null 2>&1 && ok "gamemode ipc" || bad "gamemode ipc"

echo "== services"
check() {  # check <description> <pattern expected in the status JSON>
    case "$status" in *"$2"*) ok "$1" ;; *) bad "$1 (expected $2)" ;; esac
}
check "battery found"            '"power":{"present":true'
check "brightness readable"      '"brightness":{"available":true'
check "tailscale readable"       '"tailscale":{"available":true'
check "framework_tool readable"  '"framework":{"available":true'
check "charge limit from EC"     '"chargeLimit":80'
case "$status" in *'"cpuTemp":0,'*) bad "CPU temperature not readable" ;; *) ok "CPU temperature readable" ;; esac
case "$status" in *'"memUsedGiB":0,'*) bad "memory not readable" ;; *) ok "memory readable" ;; esac
case "$status" in *'"main":""'*) bad "main monitor not detected" ;; *) ok "main monitor detected" ;; esac
case "$status" in *'"profile":""'*) warn "power profile not read yet (read when the hub opens)" ;; *) ok "power profile" ;; esac
echo "  state: $status" | cut -c1-400

echo "== log"
errors=$(qs log -p "$config" 2>&1 | grep -E 'ERROR|TypeError|ReferenceError' | grep -v 'qt.qpa')
[ -z "$errors" ] && ok "no errors in the log" || { bad "errors in the log:"; echo "$errors" | tail -5; }

[ $fail -eq 0 ] && echo "== all good" || echo "== FAILED"
exit $fail
