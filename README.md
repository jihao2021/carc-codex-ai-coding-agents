# CARC Codex config

Codex-focused starter configuration for students using the USC CARC cluster.
The structure mirrors the `uschpc/AI-Coding-Agents` repo, but the install
model is Codex-native:

- `CLAUDE.md` becomes `AGENTS.md`
- `managed-settings.json` becomes `requirements.toml` plus
  `managed_config.toml` for root installs
- `settings-user.json` becomes `settings-user.toml`
- the `PreToolUse` hook and test layout stay parallel
- `bin/carc-codex` remains only for no-root/user-tier pilots; root installs
  use Codex's own `/etc/codex/` managed policy files

Pick one setup and `cd` into its dir; everything you need is inside it.

| You want… | Go to |
|---|---|
| Install root-owned Codex requirements and managed defaults | [`root-install/`](root-install/INSTALL.md) |
| Install user-owned defaults for your account or a workshop handout | [`user-install/`](user-install/INSTALL.md) |
| Use this on the CARC Discovery cluster | [`docs/`](docs/README.md) |
| Plan an enforceable admin rollout | [`docs/ADMIN_ENFORCEMENT.md`](docs/ADMIN_ENFORCEMENT.md) |

The root setup installs `/etc/codex/requirements.toml`,
`/etc/codex/managed_config.toml`, and `/etc/codex/hooks/precheck.sh`. Students
can run the normal `codex` command; no CARC wrapper is required for the
Codex-side policy layer.

The user setup installs `~/.codex/config.toml`,
`~/.codex/hooks/precheck.sh`, and an optional `~/.local/bin/carc-codex`
launcher. It is useful for personal pilots and workshops, but it is not an
admin boundary because students own those files.

Important enforcement note: `/etc/codex/requirements.toml` controls recent
Codex clients, but it does not stop a user from running an old or unmanaged
client if that client can reach external model services directly. For a hard
cluster boundary, pair this repo with CARC network, credential, and proxy
controls. See
[`docs/ADMIN_ENFORCEMENT.md`](docs/ADMIN_ENFORCEMENT.md).

`tests/` holds the hook verification harness (`test_precheck.py`, `TEST_PLAN.md`, `_selftest.sh`). Optional, no root needed; not part of either install.
