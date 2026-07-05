#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="github-governance-skill"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MASTER_DIR="${HOME}/.agents/skills/${SKILL_NAME}"
CLAUDE_LINK="${HOME}/.claude/skills/${SKILL_NAME}"
CODEX_LINK="${HOME}/.codex/skills/${SKILL_NAME}"

PASS_COUNT=0
FAIL_COUNT=0

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  printf 'OK: %s\n' "$*"
}

fail_check() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  printf 'FAIL: %s\n' "$*" >&2
}

check_file() {
  local path="$1"
  if [ -f "$path" ]; then
    pass "File exists: ${path}"
  else
    fail_check "Missing file: ${path}"
  fi
}

check_dir() {
  local path="$1"
  if [ -d "$path" ]; then
    pass "Directory exists: ${path}"
  else
    fail_check "Missing directory: ${path}"
  fi
}

check_symlink_resolves_to() {
  local link_path="$1"
  local expected_target="$2"

  if [ ! -L "$link_path" ]; then
    fail_check "Not a symlink: ${link_path}"
    return 0
  fi

  local actual_target
  actual_target="$(readlink "$link_path")"
  if [ "$actual_target" != "$expected_target" ]; then
    fail_check "Unexpected symlink target: ${link_path} -> ${actual_target}"
    return 0
  fi

  if [ -e "$link_path" ]; then
    pass "Symlink resolves: ${link_path} -> ${expected_target}"
  else
    fail_check "Broken symlink: ${link_path} -> ${expected_target}"
  fi
}

check_no_broken_symlinks() {
  local base="$1"
  if [ ! -d "$base" ]; then
    pass "Skipped broken symlink scan; directory absent: ${base}"
    return 0
  fi

  local broken
  broken="$(find "$base" -maxdepth 1 -type l ! -exec test -e {} \; -print)"
  if [ -z "$broken" ]; then
    pass "No broken symlinks in ${base}"
  else
    fail_check "Broken symlinks found in ${base}:"
    printf '%s\n' "$broken" >&2
  fi
}

for required in README.md SKILL.md install.sh verify.sh uninstall.sh notion-summary.md .gitignore; do
  check_file "$PROJECT_DIR/$required"
done

check_file "$PROJECT_DIR/docs/usage.md"
check_file "$PROJECT_DIR/docs/governance-rules.md"
check_file "$PROJECT_DIR/docs/agent-compatibility.md"
check_file "$PROJECT_DIR/examples/codex-prompt.md"
check_file "$PROJECT_DIR/examples/opencode-prompt.md"

check_dir "$MASTER_DIR"
check_file "$MASTER_DIR/SKILL.md"
check_symlink_resolves_to "$CLAUDE_LINK" "$MASTER_DIR"
check_symlink_resolves_to "$CODEX_LINK" "$MASTER_DIR"
check_no_broken_symlinks "${HOME}/.claude/skills"
check_no_broken_symlinks "${HOME}/.codex/skills"

printf '\nVerification summary: %s passed, %s failed.\n' "$PASS_COUNT" "$FAIL_COUNT"

if [ "$FAIL_COUNT" -eq 0 ]; then
  printf 'Final status: PASS\n'
else
  printf 'Final status: FAIL\n' >&2
  exit 1
fi
