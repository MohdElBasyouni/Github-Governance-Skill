# Runbook

This repository contains an agent workflow skill, not an executable application.

## Install or refresh

With Node/npm and access to the GitHub source repositories:

```sh
npx -y skills add MohdElBasyouni/Github-Governance-Skill -g -a '*' -y
npx -y skills add MohdElBasyouni/Laptop-Migration-Skill -g -a '*' -y
npx -y skills list -g
```

The canonical skills live under `~/.agents/skills/`. Start a new agent session
if its skill list is cached. Use `$github-governance-skill` when working on a
repository, preparing a PR or performing an explicitly approved merge.

## Verify the workflow

Read the applicable repository instructions and `SKILL.md`. A merge must report
PR/check status, completed Codex GitHub review evidence for the exact final
head SHA, branch cleanup, the local `Runbook/Runbook.md` check and the
migration-check result. The migration check may correctly report no change.

No background process, Git hook or CI job is installed by these skills. There
is no server to start or stop. Edit the source repository on a branch, review
and merge it, then refresh the source-aware installation rather than editing
only the installed copy.
