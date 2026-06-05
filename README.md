# CARC Codex config

Codex-focused starter configuration for students using the USC CARC cluster.
The structure mirrors the `uschpc/AI-Coding-Agents` repo, but the install
model is Codex-native:

- `CLAUDE.md` becomes `AGENTS.md`
- `managed-settings.json` becomes `managed-settings.toml`
- `settings-user.json` becomes `settings-user.toml`
- the `PreToolUse` hook and test layout stay parallel
- `bin/carc-codex` is the Codex-specific launcher needed to enforce the same
  posture that Claude gets from managed settings

Pick one setup and `cd` into its dir; everything you need is inside it.

| You want… | Go to |
|---|---|
| Install root-owned CARC defaults and a managed `carc-codex` launcher | [`root-install/`](root-install/INSTALL.md) |
| Install user-owned defaults for your account or a workshop handout | [`user-install/`](user-install/INSTALL.md) |
| Use this on the CARC Discovery cluster | [`docs/`](docs/README.md) |
| Plan an enforceable admin rollout | [`docs/ADMIN_ENFORCEMENT.md`](docs/ADMIN_ENFORCEMENT.md) |

Each setup dir contains its own copy of `AGENTS.md`, one settings TOML file,
`hooks/precheck.sh`, `INSTALL.md`, and `bin/carc-codex`. The two `AGENTS.md`
files and the two `precheck.sh` files are identical. The settings files differ:
the root-tier `managed-settings.toml` wires the hook at
`/etc/codex-carc/hooks/precheck.sh`; the user-tier `settings-user.toml` wires
it at `$HOME/.codex/hooks/precheck.sh`.

Important difference from Claude Code: Codex does not currently have the same
file-based `/etc/claude-code/managed-settings.json` boundary. The root setup is
only enforceable if students launch Codex through `carc-codex` or an equivalent
CARC module that hides direct unsafe launch paths. Students can still install
their own Codex binary, for example with the standalone installer, so hard
enforcement belongs at the cluster network, credential, and proxy layers. See
[`docs/ADMIN_ENFORCEMENT.md`](docs/ADMIN_ENFORCEMENT.md).

`tests/` holds the hook verification harness (`test_precheck.py`, `TEST_PLAN.md`, `_selftest.sh`). Optional, no root needed; not part of either install.
