#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="github-governance-skill"
MASTER_DIR="${HOME}/.agents/skills/${SKILL_NAME}"
CLAUDE_LINK="${HOME}/.claude/skills/${SKILL_NAME}"
CODEX_LINK="${HOME}/.codex/skills/${SKILL_NAME}"

log() {
  printf '%s\n' "$*"
}

remove_managed_link() {
  local link_path="$1"
  local expected_target="$2"

  if [ -L "$link_path" ]; then
    local actual_target
    actual_target="$(readlink "$link_path")"
    if [ "$actual_target" = "$expected_target" ]; then
      rm "$link_path"
      log "Removed symlink: ${link_path}"
    else
      log "Skipped unrelated symlink: ${link_path} -> ${actual_target}"
    fi
  elif [ -e "$link_path" ]; then
    log "Skipped non-symlink path: ${link_path}"
  else
    log "No symlink present: ${link_path}"
  fi
}

remove_managed_link "$CLAUDE_LINK" "$MASTER_DIR"
remove_managed_link "$CODEX_LINK" "$MASTER_DIR"

if [ -d "$MASTER_DIR" ]; then
  printf 'Remove installed master skill at %s? [y/N] ' "$MASTER_DIR"
  read -r answer
  case "$answer" in
    y|Y|yes|YES)
      rm -rf "$MASTER_DIR"
      log "Removed installed master skill: ${MASTER_DIR}"
      ;;
    *)
      log "Kept installed master skill: ${MASTER_DIR}"
      ;;
  esac
else
  log "No installed master skill present: ${MASTER_DIR}"
fi

log "Uninstall complete."
