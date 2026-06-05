# Setup 2 — `~/.codex/` (user install, no root)

For your own account without root, or to ship to another CARC user.

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
cp AGENTS.md         ~/.codex/AGENTS.md
cp settings-user.toml ~/.codex/config.toml
cp hooks/precheck.sh ~/.codex/hooks/precheck.sh
cp bin/carc-codex    ~/.local/bin/carc-codex
chmod +x ~/.codex/hooks/precheck.sh ~/.local/bin/carc-codex
```

Back up any pre-existing `~/.codex/AGENTS.md` / `~/.codex/config.toml` first if you have them — the `cp`s overwrite.

Start `~/.local/bin/carc-codex`. Approve hooks when prompted. `/hooks` and
`/permissions` inside Codex confirm what loaded.

## Ship to another user

From the parent dir:

```bash
tar czf codex-cfg-carc.tar.gz user-install
```

Send them `codex-cfg-carc.tar.gz`. They `tar xzf` it, `cd user-install`, and follow the "Install on this account" section above.

## Caveat — user tier is NOT a boundary

`settings-user.toml` mirrors the root-tier policy shape, but it installs under
your home directory as `~/.codex/config.toml`. This is your default, not policy.
In user-tier:

- `--dangerously-bypass-approvals-and-sandbox` still works.
- A student can edit `~/.codex/config.toml`.
- A student can run `codex` directly instead of `carc-codex`.
- Project-local config, hooks, or exec policies may still apply once the project is trusted.

For a stronger classroom or cluster boundary, expose only the root-installed
`carc-codex` launcher through the supported module or course instructions.
