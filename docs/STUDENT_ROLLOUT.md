# Student Rollout Plan

This repo packages a Codex-first CARC safety pattern:

- `AGENTS.md` for model-visible CARC operating rules
- `managed-settings.toml` / `settings-user.toml` for Codex sandbox, approval,
  and hook defaults
- `bin/carc-codex` launcher wrappers for root and user installs
- `hooks/precheck.sh` for CARC-specific dynamic checks
- `tests/` for dry-run validation of `ALLOW`, `ASK`, and `BLOCK` decisions

The goal is to let students use Codex productively without turning login
nodes, shared project directories, quotas, credentials, or SLURM allocations
into accidental blast radius.

## Recommended Pilot

1. Start with a small cohort and a single supported launch command:
   `carc-codex`.
2. Deploy `root-install/` on one test login node first.
3. Expose `carc-codex` through a CARC module or course setup instructions.
4. Use `user-install/` only for workshops and personal pilots.
5. Keep `tests/` in CI and run it before every policy change.
6. Review audit logs during the pilot and tune repeated false positives.

## Boundary Model

Codex does not use the same `/etc/claude-code/managed-settings.json` mechanism
as Claude Code. For Codex, the practical boundary in this repo is:

- a root-owned `carc-codex` launcher
- forced `--sandbox workspace-write`
- forced `--ask-for-approval untrusted`
- forced hook wiring
- launcher-level blocking of the dangerous bypass/full-access options
- model-visible `AGENTS.md` instructions
- Codex's own project trust, sandbox, approval, and hook review flows

This is enforceable only if students use the managed launcher or if CARC
controls the module/PATH environment so unmanaged `codex` invocations are not
the supported workflow.

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
- Verify `managed-settings.toml` and `settings-user.toml` parse with Python
  `tomllib`.
- Verify `codex debug prompt-input` accepts the hook TOML shape.
- Start `carc-codex`, then check `/hooks` and `/permissions`.
- Confirm audit log location, permissions, retention, and review ownership.
- Confirm `python3`, `bash`, `tr`, `id`, and `hostname` exist on login and compute nodes.
- Decide whether students authenticate individually or through a course-approved billing/gateway setup.
- Publish a short student handout with approved workflows and common blocked commands.

## Local Portability Note

The hook lowercases credential-shaped filenames with `tr` instead of Bash 4's
`${var,,}` syntax. CARC Linux nodes support modern Bash, but this makes the
test harness work from macOS admin laptops too.
