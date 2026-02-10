# Oz Dev Environment Docker Images

This repository contains prebuilt Docker images for use with
[Oz environments](https://docs.warp.dev/agent-platform/cloud-agents/environments). These images
provide ready-to-use development environments for running
[Oz cloud agents](https://docs.warp.dev/agent-platform/cloud-agents/cloud-agents-overview) and
[integrations](https://docs.warp.dev/agent-platform/cloud-agents/integrations) (Slack, Linear,
GitHub Actions).

An [Oz environment](https://docs.warp.dev/agent-platform/cloud-agents/environments) defines the
execution context for an Oz cloud agent run: the **Docker image**, **repositories to clone**,
**setup commands**, and **runtime configuration**. These images handle the Docker image part so
you can get started quickly.

## Quickstart

To get started, you'll need to have the [Oz CLI](https://docs.warp.dev/reference/cli) installed
and authenticated. This is done automatically if you already have the Warp app installed.

### 1. Create an environment

Create an environment using one of the prebuilt images:

```bash
oz environment create \
  --name my-go-env \
  --docker-image warpdotdev/dev-go:1.23 \
  --repo octocat/hello-world \
  --setup-command "go mod download"
```

Alternatively, use the [Oz web app](https://oz.warp.dev) to create environments with a guided
flow, or the `/create-environment` slash command in Warp to auto-detect your project's languages
and suggest an appropriate image.

### 2. Run Oz agents

Once your environment is ready, you can:

- **Run Oz cloud agents** from the CLI, the [Oz web app](https://oz.warp.dev), or the
  [Oz Agent API & SDK](https://docs.warp.dev/reference/api-and-sdk):

```bash
oz agent run-cloud --environment env_abc123 --prompt "Fix the failing tests in src/"
```

- **Create integrations** so agents run automatically from Slack, Linear, or GitHub Actions:

```bash
oz integration create slack --environment env_abc123
```

- **Schedule agents** to run on a cron schedule for recurring tasks:

```bash
oz schedule create \
  --name "Weekly dependency updates" \
  --cron "0 10 * * 1" \
  --environment env_abc123 \
  --prompt "Check for dependency updates and open a PR"
```

- **Run skill-based agents** using reusable
  [skills](https://docs.warp.dev/agent-platform/capabilities/skills) from your repos:

```bash
oz agent run-cloud \
  --environment env_abc123 \
  --skill "owner/repo:code-review" \
  --prompt "Review the latest PR"
```

## Available images

All images are based on Ubuntu. Language-specific images extend the base image with additional
runtimes.

| Image | Contents |
||-------|----------|
|| **warpdotdev/dev-base:latest** | Node 22 + Python 3 + coding agents |
|| **warpdotdev/dev-coding-agents:latest** | Coding agent CLIs + base (no extra languages) |
|| **warpdotdev/dev-go:1.23** | Go 1.23.4 + base + coding agents |
|| **warpdotdev/dev-rust:1.83** | Rust 1.83.0 + base + coding agents |
|| **warpdotdev/dev-java:21** | Temurin JDK 21, Maven, Gradle + base + coding agents |
|| **warpdotdev/dev-dotnet:8.0** | .NET SDK 8.0 + base + coding agents |
|| **warpdotdev/dev-ruby:3.3** | Ruby 3.3 + Bundler + base + coding agents |
|| **warpdotdev/dev-web:latest** | Google Chrome, Firefox + base + coding agents |

All images include `git`, `curl`, `build-essential`, `ca-certificates`, and the following
coding agent CLIs:

- [Claude Code](https://github.com/anthropics/claude-code) (`claude`)
- [Codex CLI](https://github.com/openai/codex) (`codex`)
- [Gemini CLI](https://github.com/google-gemini/gemini-cli) (`gemini`)
- [Amp](https://ampcode.com) (`amp`)
- [GitHub CLI](https://cli.github.com) (`gh`) — useful for Copilot CLI and git workflows

Each CLI authenticates via environment variables (e.g. `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`,
`GEMINI_API_KEY`, `AMP_API_KEY`). Store these as
[Oz secrets](https://docs.warp.dev/agent-platform/cloud-agents/cloud-agent-secrets) so they are
available at runtime.

## Using a custom image

If the prebuilt images don't cover your stack, you can use any publicly accessible Docker Hub
image:

```bash
oz environment create \
  --name my-custom-env \
  --docker-image my-org/my-image:latest \
  --repo octocat/hello-world
```

You can also extend one of the prebuilt images in your own Dockerfile:

```dockerfile
FROM warpdotdev/dev-base:latest
RUN apt-get update && apt-get install -y your-package
```

## Helpful tips

- **Guided setup** — Use the `/create-environment` slash command in Warp for a guided setup flow
  that detects your project's languages and suggests the appropriate image and setup commands. See
  the [documentation](https://docs.warp.dev/agent-platform/cloud-agents/environments#create-an-environment-with-guided-setup-recommended)
  for more info.
- **One environment, many triggers** — Create one environment per codebase, then reuse it across
  Slack, Linear, CLI runs, schedules, and API calls.
- **Secrets** — For credentials and sensitive data, use
  [Oz agent secrets](https://docs.warp.dev/agent-platform/cloud-agents/cloud-agent-secrets)
  rather than baking tokens into your image.

## Documentation

- [Oz Platform Overview](https://docs.warp.dev/agent-platform/cloud-agents/platform) — CLI,
  API/SDK, orchestration, environments, and hosts
- [Oz Environments](https://docs.warp.dev/agent-platform/cloud-agents/environments) — How
  environments work and when to use them
- [Oz Cloud Agents](https://docs.warp.dev/agent-platform/cloud-agents/cloud-agents-overview) —
  Background agents that run from events, schedules, or integrations
- [Skills as Agents](https://docs.warp.dev/agent-platform/cloud-agents/skills-as-agents) —
  Run agents from reusable skill definitions
- [Oz Web App](https://oz.warp.dev) — Visual interface for managing agents, runs, schedules,
  and integrations
- [Oz CLI](https://docs.warp.dev/reference/cli) — Command-line interface for running agents
- [Oz Agent API & SDK](https://docs.warp.dev/reference/api-and-sdk) — Programmatic access to
  cloud agents

