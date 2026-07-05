# Laptop Migration Inventory: GitHub Governance Skill

## What It Is

Reusable global AI skill that enforces Mohamed's safe GitHub workflow across Codex, OpenCode, Claude-compatible skill loaders, and future AI agents.

## Install Path

Master copy:

```text
~/.agents/skills/github-governance-skill
```

Exposure symlinks:

```text
~/.claude/skills/github-governance-skill
~/.codex/skills/github-governance-skill
```

## Verify Command

From the project directory:

```bash
./verify.sh
```

## Restore Notes

1. Restore this project folder.
2. Run `./install.sh`.
3. Run `./verify.sh`.
4. Confirm Claude and Codex symlinks resolve to the master skill path.

## Safety Rules Summary

- No direct push to `main` or `master`.
- No merge to `main` or `master` without explicit Mohamed consent.
- Work on compliant branches only.
- Run discovered checks and configured review tools before push.
- Verify PR checks and review comments before completion.
- Stop and ask before force-push, remote branch deletion, history rewrite, secrets, CI/CD credential changes, production deployment config changes, or destructive filesystem actions.
