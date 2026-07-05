#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="github-governance-skill"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MASTER_DIR="${HOME}/.agents/skills/${SKILL_NAME}"
CLAUDE_LINK="${HOME}/.claude/skills/${SKILL_NAME}"
CODEX_LINK="${HOME}/.codex/skills/${SKILL_NAME}"
MARKER_FILE=".github-governance-skill-managed"

log() {
  printf '%s\n' "$*"
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

backup_path() {
  local path="$1"
  local stamp
  stamp="$(date +%Y%m%d-%H%M%S)"
  printf '%s.backup-%s-%s' "$path" "$stamp" "$$"
}

sync_skill() {
  local src="$1"
  local dest="$2"
  local tmp="${dest}.tmp-$$"

  rm -rf "$tmp"
  mkdir -p "$tmp"
  cp -R "$src/SKILL.md" "$tmp/"
  cp -R "$src/README.md" "$tmp/"
  cp -R "$src/notion-summary.md" "$tmp/"
  cp -R "$src/docs" "$tmp/"
  cp -R "$src/examples" "$tmp/"
  if [ -d "$src/agents" ]; then
    cp -R "$src/agents" "$tmp/"
  fi
  printf 'managed by %s install.sh\n' "$SKILL_NAME" > "$tmp/$MARKER_FILE"

  if [ -e "$dest" ]; then
    rm -rf "$dest"
  fi
  mv "$tmp" "$dest"
}

prepare_master_dir() {
  mkdir -p "$(dirname "$MASTER_DIR")"

  if [ -L "$MASTER_DIR" ]; then
    local resolved
    resolved="$(readlink "$MASTER_DIR")"
    local backup
    backup="$(backup_path "$MASTER_DIR")"
    mv "$MASTER_DIR" "$backup"
    log "Backed up existing master symlink ${MASTER_DIR} -> ${resolved} to ${backup}"
  elif [ -d "$MASTER_DIR" ]; then
    if [ -f "$MASTER_DIR/$MARKER_FILE" ]; then
      log "Replacing managed install: ${MASTER_DIR}"
    else
      local backup
      backup="$(backup_path "$MASTER_DIR")"
      mv "$MASTER_DIR" "$backup"
      log "Backed up existing non-symlink directory ${MASTER_DIR} to ${backup}"
    fi
  elif [ -e "$MASTER_DIR" ]; then
    local backup
    backup="$(backup_path "$MASTER_DIR")"
    mv "$MASTER_DIR" "$backup"
    log "Backed up existing non-directory ${MASTER_DIR} to ${backup}"
  fi
}

create_skill_link() {
  local link_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$link_path")"

  if [ -L "$link_path" ]; then
    local existing_target
    existing_target="$(readlink "$link_path")"
    if [ "$existing_target" = "$target_path" ]; then
      log "Symlink already correct: ${link_path} -> ${target_path}"
      return 0
    fi

    local backup
    backup="$(backup_path "$link_path")"
    mv "$link_path" "$backup"
    log "Backed up existing symlink ${link_path} -> ${existing_target} to ${backup}"
  elif [ -e "$link_path" ]; then
    local backup
    backup="$(backup_path "$link_path")"
    mv "$link_path" "$backup"
    log "Backed up existing non-symlink ${link_path} to ${backup}"
  fi

  ln -s "$target_path" "$link_path"
  log "Created symlink: ${link_path} -> ${target_path}"
}

[ -f "$SOURCE_DIR/SKILL.md" ] || fail "Missing SKILL.md in ${SOURCE_DIR}"
[ -d "$SOURCE_DIR/docs" ] || fail "Missing docs directory in ${SOURCE_DIR}"
[ -d "$SOURCE_DIR/examples" ] || fail "Missing examples directory in ${SOURCE_DIR}"

log "Installing ${SKILL_NAME}"
prepare_master_dir
sync_skill "$SOURCE_DIR" "$MASTER_DIR"
create_skill_link "$CLAUDE_LINK" "$MASTER_DIR"
create_skill_link "$CODEX_LINK" "$MASTER_DIR"

log "Install complete."
log "Master skill: ${MASTER_DIR}"
log "Claude link:  ${CLAUDE_LINK}"
log "Codex link:   ${CODEX_LINK}"
