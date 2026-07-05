# Governance Rules

## Branch Safety

- Never push directly to `main` or `master`.
- Never merge to `main` or `master` without explicit Mohamed consent.
- Always create a working branch before changes.
- Use lowercase kebab-case branch descriptions.

Allowed branch prefixes:

- `feature/`
- `fix/`
- `chore/`
- `docs/`
- `refactor/`
- `test/`
- `hotfix/`

## Required Pre-Push Workflow

Before any push, the AI agent must:

1. Check current branch.
2. Refuse direct work on `main` or `master`.
3. Check git status.
4. Run available repo checks.
5. Detect repo-specific commands from common project files.
6. Run Agency Agents Code Reviewer where available; if unavailable, report that explicitly.
7. Run CodeRabbit where available; if unavailable, report that explicitly.
8. Use Plannotator only for planning or annotation when useful.
9. Run any other configured review skill or tool from repo instructions.

## Repo Check Discovery

Look for checks in:

- `package.json`
- `pyproject.toml`
- `Makefile`
- `justfile`
- `pubspec.yaml`
- `go.mod`
- `Cargo.toml`
- repo-specific agent instructions
- CI workflow files

Prefer commands the repo already defines. Typical checks include tests, lint, analyze, typecheck, format check, and build.

## Pull Request Completion Rules

The agent must not report completion while required checks are pending or failed. If checks fail, read logs, fix the issue, push correction commits, and re-check.

## Review Comments

Read all comments from CodeRabbit, human reviewers, GitHub bots, and other tools. Address every actionable comment, reply inline where possible, record why when inline reply is not possible, and summarize the outcome.

## Merge And Cleanup

Merge only after explicit Mohamed consent. Sync the target branch, verify green checks, merge by repo convention, pull latest target branch, delete local branches only after confirming they are merged, and delete remote branches only when safe, confirmed merged, not protected, and explicitly allowed by Mohamed.

## Stop And Ask

Stop and ask before:

- pushing to `main` or `master`
- merging to `main` or `master`
- force-pushing
- deleting remote branches
- deleting untracked files
- changing repo protection/settings
- rewriting git history
- adding secrets
- changing CI/CD credentials
- touching production deployment config
- making destructive filesystem changes

## ObjectNode Reminder

For ObjectNode-related repos, agents should consider TM Forum Open APIs, O-RAN, ETSI/3GPP, SMO readiness, operational readiness, and MVP practicality. Keep this quiet for non-ObjectNode repos.
