# Student Rollout Plan

This repo packages a Codex-first CARC safety pattern:

- `AGENTS.md` for model-visible CARC operating rules
- `requirements.toml` for root-owned Codex requirements that students cannot
  weaken from user config
- `managed_config.toml` / `settings-user.toml` for Codex sandbox, approval,
  and hook defaults
- `hooks/precheck.sh` for CARC-specific dynamic checks
- `tests/` for dry-run validation of `ALLOW`, `ASK`, and `BLOCK` decisions

The goal is to let students use Codex productively without turning login
nodes, shared project directories, quotas, credentials, or SLURM allocations
into accidental blast radius.

## Recommended Pilot

1. Start with a small cohort and a recent Codex CLI version that supports
   `/etc/codex/requirements.toml`.
2. Deploy `root-install/` on one test login node first.
3. Let students run the normal `codex` command once the root policy is active.
4. Use `user-install/` only for workshops and personal pilots.
5. Keep `tests/` in CI and run it before every policy change.
6. Review audit logs during the pilot and tune repeated false positives.

## Boundary Model

Recent Codex CLI versions support root-owned Unix/Linux policy files under
`/etc/codex/`. For Codex, the practical boundary in this repo is:

- `/etc/codex/requirements.toml` for admin-enforced requirements
- `/etc/codex/managed_config.toml` for managed defaults
- `/etc/codex/hooks/precheck.sh` for CARC dynamic checks
- blocked `danger-full-access` and `approval never`
- managed hook wiring with unmanaged hooks disabled
- model-visible `AGENTS.md` instructions
- Codex's own project trust, sandbox, approval, and hook review flows

This is enforceable for Codex clients that honor `/etc/codex/requirements.toml`.
It is not sufficient as a complete cluster boundary if students can install an
old/unmanaged client and reach model services directly. See
[`ADMIN_ENFORCEMENT.md`](ADMIN_ENFORCEMENT.md) for the admin-side network,
credential, and proxy controls.

## Student Behavior To Teach

- Work in `/project2/<PI_username>_<id>/<username>` for course/project work.
- Use `/scratch1/$USER` for temporary high-I/O files only.
- Keep source code and lightweight config in `/home1/$USER`.
- Use `module spider` before installing software.
- Put `module purge` and explicit `module load` lines in every SLURM script.
- Test interactively with `--partition=debug` before larger jobs.
- Show SLURM scripts before `sbatch`.
- Avoid `cp -a`, `cp -p`, and cross-filesystem `mv` into `/project2`.
- Never read credentials, shell history, private keys, or other users' directories.

## Pre-Production Checklist

- Validate current CARC paths, quotas, partitions, and login-node hostnames.
- Run `python3 tests/test_precheck.py --no-danger user-install/hooks/precheck.sh`.
- On a CARC test node, run the full gated danger suite intentionally.
- Verify `requirements.toml`, `managed_config.toml`, and `settings-user.toml`
  parse with Python `tomllib`.
- Verify `codex debug prompt-input` accepts the hook TOML shape.
- Install `root-install/`, start `codex`, then check `/hooks` and
  `/permissions`.
- Confirm audit log location, permissions, retention, and review ownership.
- Confirm `python3`, `bash`, `tr`, `id`, and `hostname` exist on login and compute nodes.
- Decide whether students authenticate individually or through a course-approved billing/gateway setup.
- Publish a short student handout with approved workflows and common blocked commands.

## Local Portability Note

The hook lowercases credential-shaped filenames with `tr` instead of Bash 4's
`${var,,}` syntax. CARC Linux nodes support modern Bash, but this makes the
test harness work from macOS admin laptops too.
