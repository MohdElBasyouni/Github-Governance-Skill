# GitHub Governance Skill

`github-governance-skill` is a reusable global AI skill for enforcing Mohamed's safe GitHub workflow across Codex, OpenCode, Claude-compatible skill loaders, and future AI coding agents.

It is intentionally strict about branches, PR checks, review comments, and merge consent. The skill helps agents do useful work without accidentally pushing to protected branches, skipping checks, ignoring review feedback, or merging before Mohamed explicitly approves.

## What It Enforces

- No direct pushes to `main` or `master`.
- No merges to `main` or `master` without explicit Mohamed consent.
- Work starts on a compliant branch such as `feature/<short-description>` or `fix/<short-description>`.
- PR titles follow Conventional Commits, such as `feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`, `refactor: ...`, `test: ...`, and `ci: ...`.
- Pre-push checks are discovered and run from repo configuration.
- Agency Agents Code Reviewer, CodeRabbit, Plannotator, and other configured review tools are routed according to their proper roles.
- PR checks and GitHub Actions must be checked with `gh pr checks`, `gh pr view --comments`, and `gh run list` before completion is reported.
- Review comments from CodeRabbit, review bots, and humans are read, classified, addressed, replied to inline where possible, and summarized.
- Destructive or sensitive actions trigger stop-and-ask behavior.

## Branch Protection Recommendations

Recommended GitHub repository settings:

- Require a PR before merging to `main`.
- Require status checks to pass before merging.
- Block direct pushes to `main`.
- Delete merged PR branches where safe and consistent with repo policy; agents must still ask Mohamed before deleting remote branches.

## Install

From this project directory:

```bash
./install.sh
```

The installer syncs the skill to:

```text
~/.agents/skills/github-governance-skill
```

It also creates safe symlinks:

```text
~/.claude/skills/github-governance-skill -> ~/.agents/skills/github-governance-skill
~/.codex/skills/github-governance-skill -> ~/.agents/skills/github-governance-skill
```

## Verify

```bash
./verify.sh
```

## Uninstall

```bash
./uninstall.sh
```

The uninstaller removes only this skill's symlinks by default. It asks before removing the installed master copy under `~/.agents/skills`.

## Remote-Ready Setup

This project is safe to turn into a GitHub repository later. Do not create or connect a remote until Mohamed provides the remote URL.

When ready:

```bash
cd /Users/Patchivic/Library/CloudStorage/OneDrive-Personal/Coding/AI_Skills/github-governance-skill
git remote add origin <REMOTE_URL_FROM_MOHAMED>
git branch -M main
git push -u origin main
```

Do not push without Mohamed's explicit consent.
