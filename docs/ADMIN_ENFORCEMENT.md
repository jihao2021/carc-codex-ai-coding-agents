# Admin Enforcement Notes

Codex supports a root-owned managed policy layer on Unix/Linux. For CARC, that
should be the primary Codex-side enforcement path:

- `/etc/codex/requirements.toml` for admin-enforced requirements users cannot
  weaken from `~/.codex/config.toml` or CLI config overrides
- `/etc/codex/managed_config.toml` for managed launch defaults
- `/etc/codex/hooks/precheck.sh` for CARC-specific dynamic checks

## Why network policy still matters

Students can install or copy their own Codex binary. The standalone installer
is intentionally simple:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

Students may also install Codex with npm, use a binary downloaded elsewhere, or
bring a copy from another machine. Because of that, a CARC deployment should not
depend on user-owned config or PATH-only controls as the only policy layer.

## What `/etc/codex/requirements.toml` can enforce

For Codex clients that honor the managed policy layer, CARC can enforce:

- allowed approval policies, excluding `never`
- allowed sandbox modes, excluding `danger-full-access`
- managed lifecycle hooks from `/etc/codex/hooks`
- optional skipping of user, project, session, and plugin hooks
- command rules that prompt or forbid selected command prefixes
- feature pins such as disabling browser/computer-use surfaces on the cluster
- deny-read rules for common credential locations

This follows the normal `codex` command as long as the installed Codex version
supports managed requirements.

## What managed Codex config cannot enforce

Managed config cannot stop a student from running an old, modified, or
otherwise unmanaged `codex` binary if the cluster allows that binary to reach
the model service. In particular, it cannot reliably prevent:

- `curl -fsSL https://chatgpt.com/codex/install.sh | sh`
- `npm install -g @openai/codex`
- copied binaries under `$HOME`, `/project2`, or `/scratch1`
- direct use of personal ChatGPT or API credentials
- command-line flags passed to an unmanaged client that ignores requirements

Blocking only the installer URL is also incomplete. A student can use another
installer path, copy a binary, or update from a different machine.

## Enforce at the network and credential layer

For real enforcement, make the model access path the controlled boundary:

```text
student shell
  -> normal codex command
  -> /etc/codex/requirements.toml + managed hooks
  -> CARC-managed proxy or gateway
  -> approved AI provider endpoint
```

The key requirement is that login and compute nodes should not have unrestricted
direct outbound access to AI model endpoints. Instead, route approved AI traffic
through a CARC-managed proxy or gateway that can enforce:

- USC/CARC identity
- course, PI group, or project authorization
- quotas and rate limits
- allowed providers and models
- audit logging and retention
- data handling policy
- abuse response and account revocation

If direct outbound access remains open, students can use unmanaged clients and
personal credentials. In that case, `/etc/codex/requirements.toml` should be
described as the enforced policy for supported Codex clients, not as a complete
cluster-wide network boundary.

## Practical cluster controls

A defensible CARC rollout combines several layers:

- Install `/etc/codex/requirements.toml`, `/etc/codex/managed_config.toml`,
  and `/etc/codex/hooks/precheck.sh` as root-owned files.
- Install or recommend a recent Codex CLI version that supports managed
  requirements.
- Use a module only if CARC wants to distribute a specific Codex binary version
  or standardize PATH; the policy should not depend on renaming the command.
- Keep direct OpenAI, ChatGPT, npm, and release download access aligned with the
  campus network policy. Do not treat URL blocking as the only defense.
- Use Slurm cgroups, login-node process limits, filesystem quotas, Unix
  permissions, and audit logs for ordinary cluster safety.
- Do not put shared unrestricted API keys in student-readable files.
- Prefer a proxy-issued or centrally brokered credential over personal keys for
  course-managed usage.

## Optional Lmod pattern

The module can distribute a root-owned Codex binary while still letting users
type the normal `codex` command:

```lua
help([[Load the CARC-supported Codex CLI.]])

local root = "/apps/codex"

prepend_path("PATH", pathJoin(root, "bin"))

whatis("CARC-supported Codex CLI for Discovery")
```

In this layout, `/apps/codex/bin/codex` is the supported Codex CLI. The managed
policy still lives under `/etc/codex/`.

## Recommended wording for instructors

Use language like this in course material:

> Use the normal `codex` command on Discovery. CARC manages Codex policy through
> root-owned `/etc/codex/requirements.toml`, including sandbox, permissions,
> and CARC safety checks. Unmanaged or outdated Codex installations are not
> supported for course work and may be blocked by cluster network policy.

That wording is honest: the Codex-side support path is `/etc/codex/`, and the
hard cluster boundary is still the network and credential policy.
