# Using Codex on CARC Discovery

This is the student-facing quick start for running the `carc-codex` wrapper
on USC CARC Discovery. Use this for a personal pilot or workshop. For a class
or shared cluster rollout, prefer the root/module setup in
[`root-install/`](../root-install/INSTALL.md).

## 1. Log in to Discovery

Connect to the USC secure network or VPN, then log in:

```bash
ssh <usc_netid>@discovery.usc.edu
```

Discovery login nodes are for editing, light setup, job submission, and small
checks. Long or heavy computation should run inside a Slurm allocation, not on
the login node.

## 2. Install Codex CLI

Load a Node.js module, then install Codex into your user account:

```bash
module spider node
module load node

npm config set prefix ~/.local
npm install -g @openai/codex
export PATH="$HOME/.local/bin:$PATH"
```

If your shell does not already add `~/.local/bin` to `PATH`, add this line to
`~/.bashrc` or `~/.bash_profile`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Authenticate once:

```bash
codex --login
```

OpenAI's Codex CLI docs describe installation with
`npm install -g @openai/codex` and authentication with `codex --login`.

## 3. Install the CARC Codex wrapper

Clone this repo and install the user-tier bundle:

```bash
cd ~
git clone https://github.com/jihao2021/carc-codex-ai-coding-agents.git
cd carc-codex-ai-coding-agents/user-install

mkdir -p ~/.codex/hooks ~/.local/bin
cp AGENTS.md ~/.codex/AGENTS.md
cp settings-user.toml ~/.codex/config.toml
cp hooks/precheck.sh ~/.codex/hooks/precheck.sh
cp bin/carc-codex ~/.local/bin/carc-codex
chmod +x ~/.codex/hooks/precheck.sh ~/.local/bin/carc-codex
```

Back up existing `~/.codex/AGENTS.md` or `~/.codex/config.toml` first if you
already use Codex on Discovery.

## 4. Start Codex Safely

Start from a project or course work directory, not from your home root:

```bash
cd /project2/<group>/<usc_netid>
carc-codex
```

Inside Codex, run:

```text
/hooks
/permissions
```

These should show that the CARC precheck hook is loaded and that Codex is
running with workspace-write sandboxing and untrusted approvals.

## 5. Good Student Workflows

Use Codex for:

- explaining unfamiliar code
- editing scripts and notebooks
- writing Slurm scripts
- reviewing requested memory, time, partition, account, and module setup
- debugging small import or syntax issues

Good prompts:

```text
Review this Python script and suggest fixes, but do not run it yet.
```

```text
Create a Slurm smoke-test script for train.py using the debug partition.
```

```text
Check this sbatch script for account, partition, memory, module loads, and output paths.
```

## 6. Run Computation Through Slurm

For quick interactive testing:

```bash
salloc --partition=debug --time=0:30:00 --cpus-per-task=4 --mem=8G
srun --pty bash
```

Then run `carc-codex` or the command you are testing inside that allocation.
For longer work, switch from `debug` to the appropriate project partition and
request only the resources you need.

The wrapper's hook nudges or blocks risky commands on login nodes. If a command
is blocked, move the work into Slurm instead of bypassing the wrapper.

## 7. Important Limits

The user-tier install is a helpful default, not a hard security boundary.
Students can still edit files under `~/.codex` or run raw `codex` directly.
They can also self-install Codex, for example with:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

For a course, workshop, or shared CARC deployment, install
[`root-install/`](../root-install/INSTALL.md) as root and expose only
`carc-codex` through the supported module or course instructions. For real
enforcement, pair the wrapper with cluster network, credential, and proxy
controls described in [`ADMIN_ENFORCEMENT.md`](ADMIN_ENFORCEMENT.md).
