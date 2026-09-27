# Laptop Migration Inventory: GitHub Governance Skill

## What It Is

Reusable global AI skill that enforces Mohamed's safe GitHub workflow across Codex, OpenCode, Claude-compatible skill loaders, and future AI agents.

## Install Path

Installed and updated by the `skills` CLI, which records the source so it can
be refreshed later:

```bash
npx -y skills add MohdElBasyouni/Github-Governance-Skill -g -a '*' -y
```

Master copy:

```text
~/.agents/skills/github-governance-skill
```

Exposure symlinks are created by the CLI for every agent it knows about.
Agents that read `~/.agents/skills` directly — OpenCode among them — need none.

## Verify Command

```bash
npx -y skills list
```

## Restore Notes

1. Ensure Node is available.
2. Run the `skills add` command above; it registers the source in
   `~/.agents/.skill-lock.json`.
3. Run `npx -y skills update -g -y` to confirm it resolves against the source.
4. To remove it, run `npx -y skills remove github-governance-skill` so the lock
   entry goes with the files.

## Safety Rules Summary

- No direct push to `main` or `master`.
- No merge to `main` or `master` without explicit Mohamed consent.
- Work on compliant branches only.
- Use Conventional Commits for PR titles: `feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`, `refactor: ...`, `test: ...`, or `ci: ...`.
- Run discovered checks and configured review tools before push.
- Verify PR checks and review comments before completion with `gh pr checks`, `gh pr view --comments`, and `gh run list`.
- For CodeRabbit, review bots, and human comments, classify actionable vs non-actionable, fix actionable items, reply inline where possible, rerun checks, and summarize outcomes.
- Recommend branch protection that requires PRs, requires passing checks, blocks direct pushes to `main`, and enables automatic deletion of merged PR branches where safe and consistent with repo policy.
- After approved merges, verify the source branch is merged, delete the local merged branch, check whether the remote source branch still exists, and either delete it with explicit Mohamed approval or report that remote cleanup is pending approval.
- Stop and ask before force-push, remote branch deletion, history rewrite, secrets, CI/CD credential changes, production deployment config changes, or destructive filesystem actions.
