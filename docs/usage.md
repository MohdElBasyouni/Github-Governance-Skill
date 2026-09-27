# Usage

Use `github-governance-skill` whenever an AI agent is working in a Git repository and may create commits, push branches, open or update pull requests, address review comments, check GitHub Actions, merge, or clean branches.

## Codex

Invoke explicitly:

```text
Use $github-governance-skill while making this change.
```

Codex can also discover the installed symlink at:

```text
~/.codex/skills/github-governance-skill
```

## OpenCode

OpenCode can use this skill through global or project instructions. Add a project instruction such as:

```text
Use the github-governance-skill workflow for all git, PR, review, and merge operations.
```

Suggested placement:

- Global OpenCode agent instructions for account-wide behavior.
- Project `AGENTS.md` or OpenCode instruction files for repository-specific behavior.
- Repo onboarding docs when a project needs human-visible governance rules.

For project-level OpenCode agents, reference the master path:

```text
~/.agents/skills/github-governance-skill
```

## Claude-Compatible Skill Loading

Claude-compatible loaders can discover:

```text
~/.claude/skills/github-governance-skill
```

The symlink points to the shared master skill under `~/.agents/skills`.

## Mohamed's Shared Skills Architecture

Current architecture:

```text
master skills:   ~/.agents/skills
lock file:       ~/.agents/.skill-lock.json
```

`~/.agents/skills` is the source of truth and the only place the skill is
actually installed. The `skills` CLI records where each skill came from in
`~/.agents/.skill-lock.json` and creates the per-agent symlinks, so no tool
needs a hand-managed copy.

Agents that read `~/.agents/skills` directly — OpenCode among them — pick the
skill up with no symlink at all. The rest get one created by the installer.

## Managing the Install

Install, update and remove all go through the `skills` CLI, which is the same
installer used for the rest of the machine's skills:

```bash
npx -y skills add MohdElBasyouni/Github-Governance-Skill -g -a '*' -y
npx -y skills update -g -y
npx -y skills remove github-governance-skill
```

Always remove with `skills remove` rather than deleting files by hand. The lock
entry outlives the files otherwise, and the next `skills update` reinstalls the
skill with no explanation.

### Without Node

The CLI requires Node. On a machine that has none, copy the repository into
place by hand:

```bash
git clone https://github.com/MohdElBasyouni/Github-Governance-Skill.git
cp -R Github-Governance-Skill ~/.agents/skills/github-governance-skill
```

The skill will work, but nothing records that it came from a source, so
`skills update` cannot refresh it and it will drift from upstream unnoticed.
Re-run the `skills add` command above as soon as Node is available.
