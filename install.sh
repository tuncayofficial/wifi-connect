#!/usr/bin/env bash
#
# wifi-connect — beginner-friendly iwctl installer & launcher
# (c) 2025 @tuncayofficial

set -euo pipefail

# ─── Config ──────────────────────────────────────────────────────────
PACKAGE="iwd"
COMMAND="iwctl"
SPINNER_CHARS='|/-\'
INSTALL_TIMEOUT=30   # seconds to wait for install
# ────────────────────────────────────────────────────────────────────

# ─── Helpers ─────────────────────────────────────────────────────────
RED=$(tput setaf 1)   ; GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3); BLUE=$(tput setaf 4)
BOLD=$(tput bold)      ; RESET=$(tput sgr0)

info()    { echo "${BLUE}${BOLD}[INFO]${RESET} $*"; }
success() { echo "${GREEN}${BOLD}[OK]${RESET} $*"; }
warn()    { echo "${YELLOW}${BOLD}[WARN]${RESET} $*"; }
error()   { echo "${RED}${BOLD}[ERROR]${RESET} $*" >&2; }

spinner() {
  local pid=$1 delay=0.1
  while kill -0 "$pid" 2>/dev/null; do
    for c in $SPINNER_CHARS; do
      printf "\r${BLUE}%s${RESET}" "$c"
      sleep "$delay"
    done
  done
  printf "\r"  # clear spinner
}

require_root() {
  if (( EUID != 0 )); then
    error "This script must be run as root (or via sudo)."
    exit 1
  fi
}

prompt_yes_no() {
  local prompt default reply
  prompt="$1"; default=${2:-Y}
  echo -n "${prompt} [${default}/$( [ "$default" == "Y" ] && echo "n" || echo "y" )]: "
  read -r reply
  reply=${reply:-$default}
  case "$reply" in
    [Yy]*) return 0 ;;
    *)     return 1 ;;
  esac
}

# ─── Main ────────────────────────────────────────────────────────────
clear
info "Welcome to Wi-Fi Connect (iwctl) installer!"
info "This script will install & launch '${COMMAND}' for you."
echo

require_root

if ! prompt_yes_no "Install package '${PACKAGE}' now?" "Y"; then
  warn "Installation cancelled by user."
  exit 0
fi

info "Updating package database..."
pacman -Sy --noconfirm > /dev/null 2>&1

info "Installing '${PACKAGE}' (this may take a moment)..."
pacman -S --noconfirm "$PACKAGE" &
spinner $!
success "Package '${PACKAGE}' installed."

info "Enabling iwd service at boot..."
systemctl enable iwd --now
success "iwd service enabled and started."

echo
info "Ready to launch ${COMMAND}."
if prompt_yes_no "Run ${COMMAND} now?" "Y"; then
  success "Starting ${COMMAND}…"
  exec "$COMMAND"
else
  info "You can start it anytime by running: ${BOLD}${COMMAND}${RESET}"
  exit 0
fi
