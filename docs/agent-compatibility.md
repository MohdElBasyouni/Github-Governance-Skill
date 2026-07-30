# Agent Compatibility

`github-governance-skill` is designed as a portable governance layer for AI coding agents.

## Codex

Codex reads skills from `~/.codex/skills`. The installer creates:

```text
~/.codex/skills/github-governance-skill -> ~/.agents/skills/github-governance-skill
```

## Claude-Compatible Agents

Claude-compatible skill loaders read from `~/.claude/skills`. The installer creates:

```text
~/.claude/skills/github-governance-skill -> ~/.agents/skills/github-governance-skill
```

## OpenCode

OpenCode can use this skill through:

- global instructions
- project-level agent instructions
- direct references to `~/.agents/skills/github-governance-skill`
- future skill discovery integrations

## Future AI Agents

Future agents should treat `~/.agents/skills` as the master skills directory and expose symlinks or adapters into their own skill/plugin discovery paths.

## Code Review Tool Routing

- Agency Agents Code Reviewer: use for two-axis agency review when available.
- CodeRabbit: use for CodeRabbit CLI or GitHub PR review when explicitly requested or configured.
- Plannotator: use for planning, browsing, and annotations when useful; do not substitute it for code review.

Never collapse one review tool into another. If a requested review tool is unavailable, report that tool-specific failure and ask how to proceed.
