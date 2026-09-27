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
- Enable automatic deletion of merged PR branches where safe and consistent with repo policy.
- If automatic deletion is not enabled, agents must still ask Mohamed before deleting remote branches.

## Post-Merge Cleanup

After an approved merge, agents must verify the source branch is merged, delete the local merged branch, check whether the remote source branch still exists, and either delete it with explicit Mohamed approval or report that remote cleanup is pending approval. Agents must prune remote-tracking branches and report the final branch state.

## Install

This is a repository-root skill, so it installs with the
[`skills`](https://github.com/vercel-labs/skills) CLI — the same source-aware
installer used for every other skill on the machine. It records the source in
`~/.agents/.skill-lock.json`, which is what lets `skills update` refresh it
later.

```bash
npx -y skills add MohdElBasyouni/Github-Governance-Skill -g -a '*' -y
```

The skill is installed once, at:

```text
~/.agents/skills/github-governance-skill
```

and symlinked into every agent directory the CLI knows about. Agents that read
`~/.agents/skills` directly — OpenCode among them — need no symlink at all.

To see what the repository offers before changing anything:

```bash
npx -y skills add MohdElBasyouni/Github-Governance-Skill -l
```

### No Node?

The CLI needs Node. On a machine without it, install by hand:

```bash
git clone https://github.com/MohdElBasyouni/Github-Governance-Skill.git
cp -R Github-Governance-Skill ~/.agents/skills/github-governance-skill
```

A hand-placed copy has no recorded source, so `skills update` will not see it
and it will silently go stale. Re-run the command above once Node is available.

## Update

```bash
npx -y skills update -g -y
```

## Verify

There is no separate verification script: the installer compares the installed
copy against the source itself, so `skills add` and `skills update` are the
check. To see what is registered:

```bash
npx -y skills list
```

## Uninstall

```bash
npx -y skills remove github-governance-skill
```

This removes the installed copy, the symlinks, **and** the lock entry. Removing
the files by hand instead leaves the lock entry behind, and the next
`skills update` quietly reinstalls the skill.

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
