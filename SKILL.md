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

## Minimal CI, Local Validation

- Keep hosted CI to the smallest meaningful set of required merge or release
  checks and essential checks that need a hosted environment. Do not add a CI
  workflow by default. Avoid duplicate jobs, redundant triggers, and broad
  matrices when a single fast check can serve the same purpose.
- Before pushing, run the applicable heavy work locally on the revision being
  pushed: full test suites, integration tests, build matrices, and benchmarks
  as relevant. Record the commands and outcomes in the PR. If a local check is
  blocked, report it and what is needed to run it; do not silently move it to
  hosted CI or count it as passed.
- Preserve existing required checks and branch protections. Local results do
  not satisfy required hosted checks. Reducing CI does not authorize removing
  or bypassing a required gate.

## Before Push

1. Check current branch with `git branch --show-current`.
2. Refuse to push from `main` or `master`.
3. Check `git status --short`.
4. Detect and run applicable repo checks locally, such as tests, lint, analyze, typecheck, format check, and build.
5. Discover commands from repo files including `package.json`, `pyproject.toml`, `Makefile`, `justfile`, `pubspec.yaml`, `go.mod`, `Cargo.toml`, and project instructions.
6. Run Agency Agents Code Reviewer when available; if unavailable, report that explicitly.
7. Run CodeRabbit when available; if unavailable, report that explicitly.
8. Use Plannotator for planning or annotation when useful, never as a replacement for code review.
9. Run any other configured review skill/tool named in repo instructions.

## Pull Requests And Checks

When a PR exists or is created:

- Check PR status and GitHub Actions/workflow checks.
- Before reporting PR work done, run or check `gh pr checks`, `gh pr view --comments`, and `gh run list`.
- After every push, confirm all required checks are green for the exact current PR head SHA before reporting completion or merging. After merge, verify CI on the target branch and fix any regression through the normal PR workflow.
- If checks fail, read logs, fix issues, push correction commits, and re-check.
- If checks are pending, failed, or unavailable, report the exact gap and keep the merge or release pending.

## Codex GitHub Review Gate

Before every merge, verify the actual Codex GitHub review independently of CI:

1. Read the PR's current head commit SHA, Codex review summary/results, review
   submissions, conversation comments and inline review threads.
2. Wait until Codex code review explicitly reports **completed for that exact
   final head SHA**. A queued/running review, an eyes reaction, green CI, no
   inline comments yet, or a completed review of an older commit is not a pass.
3. Read every finding and thread. Fix and verify actionable issues, and resolve
   their threads only after the issue is addressed. Explain non-actionable
   findings rather than silently dismissing them. Do not merge with unresolved
   actionable findings.
4. Every new push invalidates the previous review gate. Rerun applicable local
   checks/CI and wait for Codex to complete review of the new final head; request
   a review through the repository's supported workflow if it did not trigger.
5. Immediately before merging, re-read the PR head and confirm it still matches
   the completed review's SHA, with no unresolved actionable findings. Use an
   expected-head SHA merge guard when available. Report the reviewed SHA and a
   link to the completed review evidence.

If Codex review is unavailable, skipped, errored, or cannot be confirmed for the
final head, keep the merge pending and report that specific gap. Ask how to
proceed rather than silently bypassing the review. A review exception, if the
user explicitly authorizes one, must be disclosed as an exception; never report
an unreviewed commit as reviewed. No automatic timeout authorizes a merge.

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
- Require the minimal set of meaningful hosted status checks to pass before merging.
- Block direct pushes to `main`.
- Enable automatic deletion of merged PR branches where safe and consistent with repo policy.
- If automatic deletion is not enabled, agents must still ask Mohamed before deleting remote branches.

## Merge Workflow

Only when Mohamed explicitly instructs a merge to `main` or `master`:

1. Confirm the consent is explicit.
2. Fetch remote.
3. Sync local `main` or `master` with origin.
4. Verify PR checks are green and the Codex GitHub Review Gate above is satisfied for the current final head.
5. Merge using the repo's standard method.
6. Pull the latest target branch after merge and verify its CI as described above.
7. Confirm the source branch is merged into the updated target branch.
8. Delete the local source branch when it is safely merged.
9. Check whether the remote source branch still exists.
10. If the remote source branch exists, delete it only when safe, confirmed merged, not protected, and explicitly allowed by Mohamed.
11. If remote deletion is not explicitly allowed, leave the branch in place and report that cleanup is pending Mohamed approval.
12. Fetch with prune after cleanup.
13. Check the merged repository's local `Runbook/Runbook.md` using the Local Runbook Check below.
14. Load the installed `laptop-migration-skill` and check the pinned merged PR for a concrete Laptop-Migration documentation gap. If the skill or migration checkout is unavailable, report that check as pending; do not install software or run a backup implicitly.
15. Report local and remote branch cleanup, runbook status and migration-check result clearly, including any branches intentionally left behind.

## Local Runbook Check

For every approved PR merge, inspect the **local checkout of that repository**
after it is synced to the merged target revision. The root must contain a
`Runbook/` folder with `Runbook.md` inside. This is a local documentation check,
not a request to launch the app or query production services.

- Keep the runbook concise: prerequisites, dependency/setup commands, required
  configuration variable names, how to run the code, one safe verification
  command or expected result, and shutdown/cleanup only where relevant.
- Derive commands from the repository's actual manifests, scripts and maintained
  docs. For a skill/library/docs-only repository, explain how to install/use or
  validate it rather than inventing an application startup command. Link to
  detailed docs instead of duplicating them. Do not include credential values.
- Verify changed entrypoints, runtime requirements and setup instructions against
  the merged revision. Preserve valid user-authored details and unrelated work.
- When preparing a PR, include any needed runbook correction in that branch so
  the post-merge check can normally be a no-op. If missing or stale only after
  merge, make the smallest authorized correction on a new branch/worktree and
  use the normal PR/check/merge process; never edit or push the default branch.
  When permission is missing, report the exact proposed correction and ask only
  for that permission. Existing explicit approval still applies to its scope.
- A runbook-only follow-up that is now correct ends the check. Do not create
  repeated no-op PRs, commit per-merge audit logs, add CI jobs, install hooks, or
  start a watcher. Report missing local access as a blocker rather than claiming
  the folder was verified remotely.

## ObjectNode Reminder

For ObjectNode-related repositories, quietly consider TM Forum Open APIs, O-RAN, ETSI/3GPP, SMO readiness, operational readiness, and MVP practicality. Keep this reminder out of the way for non-ObjectNode repos.
