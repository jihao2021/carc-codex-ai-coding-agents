# CARC Codex config

Codex-focused starter configuration for students using the USC CARC cluster.
The structure mirrors the `uschpc/AI-Coding-Agents` repo, but the install
model is Codex-native: `AGENTS.md`, `config.toml`, a `PreToolUse` hook, tests,
and a `carc-codex` launcher.

Pick one setup and `cd` into its dir; everything you need is inside it.

| You want… | Go to |
|---|---|
| You want... | Go to |
|---|---|
| Install root-owned CARC defaults and a managed `carc-codex` launcher | [`root-install/`](root-install/INSTALL.md) |
| Install user-owned defaults for your account or a workshop handout | [`user-install/`](user-install/INSTALL.md) |

Each dir contains its own copy of `AGENTS.md`, `config.toml`,
`bin/carc-codex`, and `hooks/precheck.sh`. The root-tier config wires the
hook at `/etc/codex-carc/hooks/precheck.sh`; the user-tier config wires it at
`$HOME/.codex/hooks/precheck.sh`.

Important difference from Claude Code: Codex does not currently have the same
file-based `/etc/claude-code/managed-settings.json` boundary. The root setup is
only enforceable if students launch Codex through the managed `carc-codex`
wrapper or an equivalent CARC module that hides direct unsafe launch paths.

`tests/` holds the hook verification harness (`test_precheck.py`, `TEST_PLAN.md`, `_selftest.sh`). Optional, no root needed; not part of either install.
