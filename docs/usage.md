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
Claude exposure: ~/.claude/skills
Codex exposure:  ~/.codex/skills
OpenCode:        global/project instructions and skill discovery
```

The master copy is the source of truth. Claude and Codex paths are safe symlinks to that master copy.
