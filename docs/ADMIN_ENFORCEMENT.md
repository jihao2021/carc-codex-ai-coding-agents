# Admin Enforcement Notes

`carc-codex` is a supported safe entrypoint. It is not, by itself, a cluster
security boundary.

Students can install or copy their own Codex binary. The standalone installer
is intentionally simple:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

Students may also install Codex with npm, use a binary downloaded elsewhere, or
bring a copy from another machine. Because of that, a CARC deployment should not
depend on the wrapper as the only control.

## What the wrapper can enforce

When students use `carc-codex`, the launcher can consistently apply:

- workspace-write sandboxing
- untrusted approval mode
- CARC precheck hooks
- CARC-specific `AGENTS.md` operating guidance
- launcher-level blocking for dangerous Codex flags
- a consistent support and training path for classes and workshops

This is valuable for user experience, teaching, and normal support. It helps
students do the right thing without remembering every option.

## What the wrapper cannot enforce

The wrapper cannot stop a student from running another `codex` binary if the
cluster allows that binary to reach the model service. In particular, it cannot
reliably prevent:

- `curl -fsSL https://chatgpt.com/codex/install.sh | sh`
- `npm install -g @openai/codex`
- copied binaries under `$HOME`, `/project2`, or `/scratch1`
- direct use of personal ChatGPT or API credentials
- command-line flags passed to an unmanaged Codex binary

Blocking only the installer URL is also incomplete. A student can use another
installer path, copy a binary, or update from a different machine.

## Enforce at the network and credential layer

For real enforcement, make the model access path the controlled boundary:

```text
student shell
  -> module load codex-carc
  -> root-owned carc-codex wrapper
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
personal credentials. In that case, `carc-codex` should be described as the
supported configuration, not a mandatory security boundary.

## Practical cluster controls

A defensible CARC rollout combines several layers:

- Install the supported Codex binary and `carc-codex` wrapper in root-owned
  paths.
- Provide an Lmod module such as `codex-carc` that puts the wrapper first on
  `PATH`.
- Optionally provide both `codex` and `carc-codex` command names in the module
  so normal `codex` usage still lands on the managed launcher.
- Keep direct OpenAI, ChatGPT, npm, and release download access aligned with the
  campus network policy. Do not treat URL blocking as the only defense.
- Use Slurm cgroups, login-node process limits, filesystem quotas, Unix
  permissions, and audit logs for ordinary cluster safety.
- Do not put shared unrestricted API keys in student-readable files.
- Prefer a proxy-issued or centrally brokered credential over personal keys for
  course-managed usage.

## Example Lmod pattern

The module should make the managed path the default:

```lua
help([[Load the CARC-supported Codex wrapper.]])

local root = "/apps/codex-carc"

prepend_path("PATH", pathJoin(root, "bin"))
setenv("CARC_CODEX_POLICY_ROOT", "/etc/codex-carc")
setenv("CARC_CODEX_REAL", pathJoin(root, "libexec", "codex"))

whatis("CARC-supported Codex wrapper for Discovery")
```

In this layout, `/apps/codex-carc/bin/carc-codex` is the wrapper and
`/apps/codex-carc/libexec/codex` is the root-owned real Codex binary. A second
wrapper named `/apps/codex-carc/bin/codex` can point to `carc-codex` if CARC
wants the ordinary `codex` command to use the managed policy by default.

## Recommended wording for instructors

Use language like this in course material:

> `carc-codex` is the only supported Codex command for this class on Discovery.
> It configures the sandbox, permissions, and CARC safety checks. Other Codex
> installations are not supported for course work and may be blocked by cluster
> network policy.

That wording is honest: the support path is the wrapper, and the enforcement
path is the cluster network and credential policy.
