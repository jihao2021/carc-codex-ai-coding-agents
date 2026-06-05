# Setup 2 — `~/.codex/` (user install, no root)

For your own account without root, or to ship to another CARC user.

User install is config-first: it overwrites `~/.codex/config.toml` with CARC
defaults so users can start Codex with the normal `codex` command. The optional
`carc-codex` wrapper is included only for no-root workshops that want a stronger
recommended launch command.

This dir contains everything you need:

```
AGENTS.md
settings-user.toml
bin/carc-codex
hooks/precheck.sh
INSTALL.md          (this file)
```

## Install on this account

From inside this dir:

```bash
mkdir -p ~/.codex/hooks ~/.local/bin
cp AGENTS.md          ~/.codex/AGENTS.md
cp settings-user.toml ~/.codex/config.toml
cp hooks/precheck.sh  ~/.codex/hooks/precheck.sh
chmod +x ~/.codex/hooks/precheck.sh
```

This is the Codex equivalent of the Claude user install:

| Claude Code | Codex |
|---|---|
| `~/.claude/CLAUDE.md` | `~/.codex/AGENTS.md` |
| `~/.claude/settings.json` | `~/.codex/config.toml` |
| `~/.claude/hooks/precheck.sh` | `~/.codex/hooks/precheck.sh` |
| `claude` | `codex` |

Back up any pre-existing `~/.codex/AGENTS.md` or `~/.codex/config.toml` first
if you have them. The `cp settings-user.toml ~/.codex/config.toml` line
intentionally overwrites the user's default Codex config for this account.

Start Codex normally:

```bash
codex
```

Approve hooks when prompted. `/hooks` and `/permissions` inside Codex confirm
what loaded.

## Optional wrapper

For a no-root workshop where you want one stronger recommended launch command,
also install the wrapper:

```bash
cp bin/carc-codex ~/.local/bin/carc-codex
chmod +x ~/.local/bin/carc-codex
```

When users start `carc-codex`, it passes these startup settings even if
`~/.codex/config.toml` has drifted:

- `--sandbox workspace-write`
- `--ask-for-approval untrusted`
- `--disable browser_use`
- `--disable computer_use`
- `--disable in_app_browser`
- `sandbox_workspace_write.network_access=false`
- `web_search="disabled"`
- the CARC `PreToolUse` hook under `~/.codex/hooks/precheck.sh`

It also rejects obvious attempts to turn those back on through `carc-codex`,
such as `--search`, `--enable computer_use`,
`--sandbox danger-full-access`, and `--ask-for-approval never`.

The wrapper is still user-owned and optional. For true enforcement, use the
root install's `/etc/codex/requirements.toml`.

## Ship to another user

From the parent dir:

```bash
tar czf codex-cfg-carc.tar.gz user-install
```

Send them `codex-cfg-carc.tar.gz`. They `tar xzf` it, `cd user-install`, and follow the "Install on this account" section above.

## Caveat — user tier is NOT a boundary

`settings-user.toml` mirrors the root-tier defaults, but it installs under your
home directory as `~/.codex/config.toml`. This is your default, not policy.
In user-tier:

- Raw `codex` reads `~/.codex/config.toml`, but command-line flags can still
  override user-owned defaults.
- `carc-codex` blocks `--dangerously-bypass-approvals-and-sandbox`, but raw
  `codex` does not.
- A student can edit `~/.codex/config.toml`.
- Project-local config, hooks, or exec policies may still apply once the project is trusted.

For a stronger classroom or cluster boundary, install
`root-install/requirements.toml` as `/etc/codex/requirements.toml` and
`root-install/managed_config.toml` as `/etc/codex/managed_config.toml`.
