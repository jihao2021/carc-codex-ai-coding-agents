# Setup 1 — `/etc/codex-carc/` plus `carc-codex` launcher

For when you have root on the target node (`discovery1/2`, `endeavour1/2`).

This dir contains everything you need:

```
AGENTS.md
config.toml
bin/carc-codex
hooks/precheck.sh
INSTALL.md          (this file)
```

## Install

From inside this dir, as root on the target node:

```bash
sudo install -d -m 0755 -o root -g root /etc/codex-carc /etc/codex-carc/hooks /usr/local/bin
sudo install -m 0644 -o root -g root AGENTS.md             /etc/codex-carc/
sudo install -m 0644 -o root -g root config.toml           /etc/codex-carc/
sudo install -m 0755 -o root -g root hooks/precheck.sh     /etc/codex-carc/hooks/
sudo install -m 0755 -o root -g root bin/carc-codex        /usr/local/bin/carc-codex
```

If the real Codex binary is not found as `codex` on `PATH`, set
`CARC_CODEX_REAL` in your modulefile or wrapper environment to its absolute
path.

## Boundary model

The root-owned files make the policy auditable, and the launcher enforces the
important runtime defaults:

- `--sandbox workspace-write`
- `--ask-for-approval untrusted`
- `--enable hooks`
- a `PreToolUse` hook at `/etc/codex-carc/hooks/precheck.sh`
- blocking `--dangerously-bypass-approvals-and-sandbox`
- blocking `--sandbox danger-full-access`
- blocking `--ask-for-approval never`

This is only a hard boundary if students are instructed, trained, or required
to use `carc-codex` rather than invoking another unmanaged Codex binary.

## Verify

```bash
sudo bash -n /etc/codex-carc/hooks/precheck.sh && echo "hook OK"
python3 -c 'import pathlib,tomllib; tomllib.loads(pathlib.Path("/etc/codex-carc/config.toml").read_text()); print("config OK")'
carc-codex --help >/dev/null && echo "launcher OK"
```

Then in a user session: start `carc-codex`, run `/hooks` to review the hook,
and run `/permissions` to confirm the active sandbox and approval mode.
