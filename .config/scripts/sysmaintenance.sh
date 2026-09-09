#!/usr/bin/env bash
# ------------------------------------------------------------
# Arch "Spring‑Clean" Maintenance Script
# (interactive, abort‑safe, log‑to‑file)
# ------------------------------------------------------------
#  • Designed for periodic housekeeping (monthly‑ish), rodado manualmente.
#  • Não faz upgrade do sistema — isso é feito à parte via yay.
#  • Automatically detects **paru** or **yay** and uses whichever is found.
#  • Requires: pacman‑contrib (paccache), pacdiff, plus the detected AUR helper.
# ------------------------------------------------------------

set -euo pipefail
trap 'echo "[!] Aborted by user"; exit 1' INT TERM

# ---------- Detect AUR helper ---------------------------------------------
if command -v paru &>/dev/null; then
  AUR=paru
elif command -v yay &>/dev/null; then
  AUR=yay
else
  echo "Error: neither paru nor yay found in PATH." >&2
  exit 1
fi
# --------------------------------------------------------------------------

# ---------- Config ---------------------------------------------------------
LOG_DIR="$HOME/.local/var/log"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/spring-clean-$(date +%F_%H-%M-%S).log"

PACCACHE_RETAIN=2   # keep N package versions
CACHE_DAYS=30       # prune ~/.cache entries older than N days
JOURNAL_RETAIN="7d" # e.g. 500M or 7d
# --------------------------------------------------------------------------

exec > >(tee -a "$LOG_FILE") 2>&1

# ---------- Helpers --------------------------------------------------------
confirm() {
  read -r -p "${1:-Are you sure? [y/N]} " ans
  [[ "$ans" =~ ^([yY][eE][sS]|[yY])$ ]]
}

announce() { printf "\n\e[1;34m==> %s\e[0m\n" "$1"; }

announce "Arch Spring‑Clean starting $(date)  —  using $AUR"

# ---------- 1. Pacman cache trim ------------------------------------------
announce "Pacman cache trim (keeping latest $PACCACHE_RETAIN)"
current_cache=$(sudo du -sh /var/cache/pacman/pkg | cut -f1)
echo "Current cache: $current_cache"
if confirm "Clean pacman cache now? [y/N]"; then
  sudo paccache -vrk"$PACCACHE_RETAIN"
  sudo paccache -ruk0
fi
new_cache=$(sudo du -sh /var/cache/pacman/pkg | cut -f1)
echo "Cache after trim: $new_cache"

# ---------- 2. Orphaned packages ------------------------------------------
announce "Removing orphaned packages"
mapfile -t ORPHANS < <($AUR -Qtdq || true)
if ((${#ORPHANS[@]})); then
  printf "Found %d orphan(s):\n%s\n" "${#ORPHANS[@]}" "${ORPHANS[*]}"
  if confirm "Remove these? [y/N]"; then
    sudo pacman -Rns "${ORPHANS[@]}"
  fi
else
  echo "No orphans detected."
fi

# ---------- 3. $HOME/.cache prune ----------------------------------------
announce "Pruning ~/.cache (unused > $CACHE_DAYS days)"
cache_before=$(du -sh ~/.cache | cut -f1)
echo "Before: $cache_before"
if confirm "Clean ~/.cache now? [y/N]"; then
  find ~/.cache -type f -mtime +"$CACHE_DAYS" -print -delete
  find ~/.cache -type d -empty -print -delete
fi
cache_after=$(du -sh ~/.cache | cut -f1)
echo "After: $cache_after"

# ---------- 4. Journald rotate & vacuum ----------------------------------
announce "Vacuuming journald logs ($JOURNAL_RETAIN)"
journal_before=$(journalctl --disk-usage | awk '{print $NF}')
if confirm "Rotate & vacuum journald now? [y/N]"; then
  sudo journalctl --rotate
  sudo journalctl --vacuum-time="$JOURNAL_RETAIN"
fi
journal_after=$(journalctl --disk-usage | awk '{print $NF}')
echo "Journald: $journal_before  ->  $journal_after"

# ---------- 5. Failed systemd units --------------------------------------
announce "Scanning for failed systemd services"
if systemctl --failed --quiet; then
  echo "No failed units detected."
else
  systemctl --failed --no-pager --plain
fi

announce "Spring‑Clean finished in ${SECONDS}s — log saved to $LOG_FILE"
