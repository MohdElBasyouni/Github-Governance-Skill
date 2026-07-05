---
name: github-governance-skill
description: Enforce Mohamed's safe GitHub workflow for Codex, OpenCode, Claude-compatible skills, and other AI coding agents. Use when an agent is modifying a git repository, preparing commits, pushing branches, opening or updating pull requests, checking GitHub Actions, responding to review comments, or merging/cleaning branches.
---

# GitHub Governance Skill

## Non-Negotiable Rules

- Never push directly to `main` or `master`.
- Never merge to `main` or `master` without Mohamed's explicit consent.
- Create or switch to a working branch before code changes.
- Stop and ask before force-pushing, rewriting history, deleting remote branches, deleting untracked files, changing repo protections/settings, adding secrets, changing CI/CD credentials, touching production deployment config, or making destructive filesystem changes.
- Prefer small, reviewable pull requests.

## Branch Rules

Use lowercase kebab-case descriptions:

- `feature/<short-description>`
- `fix/<short-description>`
- `chore/<short-description>`
- `docs/<short-description>`
- `refactor/<short-description>`
- `test/<short-description>`
- `hotfix/<short-description>`

If on `main` or `master`, refuse direct work and create a compliant branch before editing.

## Pull Request Title Rules

PR titles must follow Conventional Commits:

- `feat: ...`
- `fix: ...`
- `docs: ...`
- `chore: ...`
- `refactor: ...`
- `test: ...`
- `ci: ...`

## Before Push

1. Check current branch with `git branch --show-current`.
2. Refuse to push from `main` or `master`.
3. Check `git status --short`.
4. Detect and run repo checks that exist, such as tests, lint, analyze, typecheck, format check, and build.
5. Discover commands from repo files including `package.json`, `pyproject.toml`, `Makefile`, `justfile`, `pubspec.yaml`, `go.mod`, `Cargo.toml`, and project instructions.
6. Run Agency Agents Code Reviewer when available; if unavailable, report that explicitly.
7. Run CodeRabbit when available; if unavailable, report that explicitly.
8. Use Plannotator for planning or annotation when useful, never as a replacement for code review.
9. Run any other configured review skill/tool named in repo instructions.

## Pull Requests And Checks

When a PR exists or is created:

- Check PR status and GitHub Actions/workflow checks.
- Before reporting PR work done, run or check `gh pr checks`, `gh pr view --comments`, and `gh run list`.
- Confirm all required checks are green before reporting completion.
- If checks fail, read logs, fix issues, push correction commits, and re-check.
- If checks are pending or failed, report the exact incomplete status instead of saying the task is done.

## Review Comments

For CodeRabbit, human reviewers, GitHub bots, and other review tools:

- Read all comments.
- Classify each as actionable or non-actionable.
- Address every actionable comment.
- Reply inline where possible.
- If inline reply is not possible, record why and summarize the resolution in the PR or final report.
- Do not ignore unresolved review comments.
- Re-run checks after changes.
- Summarize what was addressed.

## Branch Protection Recommendations

Recommend repository protection rules that:

- Require a pull request before merging to `main`.
- Require status checks to pass before merging.
- Block direct pushes to `main`.
- Delete merged PR branches where safe and consistent with repo policy; agents must still ask Mohamed before deleting remote branches.

## Merge Workflow

Only when Mohamed explicitly instructs a merge to `main` or `master`:

1. Confirm the consent is explicit.
2. Fetch remote.
3. Sync local `main` or `master` with origin.
4. Verify PR checks are green.
5. Merge using the repo's standard method.
6. Pull latest target branch after merge.
7. Delete local branches only after confirming they are merged.
8. Delete remote branches only when safe, confirmed merged, not protected, and explicitly allowed by Mohamed.
9. Never delete protected, active, unknown, or unmerged branches.
10. Report branch cleanup clearly.

## ObjectNode Reminder

For ObjectNode-related repositories, quietly consider TM Forum Open APIs, O-RAN, ETSI/3GPP, SMO readiness, operational readiness, and MVP practicality. Keep this reminder out of the way for non-ObjectNode repos.
