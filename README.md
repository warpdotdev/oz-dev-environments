# Oz Dev Environment Docker Images

This repository contains prebuilt Docker images for use with
[Oz environments](https://docs.warp.dev/agent-platform/cloud-agents/environments). These images provide ready-to-use
development environments for running [Oz agents](https://docs.warp.dev/agent-platform/cloud-agents/cloud-agents-overview)
and [Oz integrations](https://docs.warp.dev/agent-platform/cloud-agents/integrations).

## Quickstart

To get started, you'll need to have the [Oz CLI](https://docs.warp.dev/reference/cli) installed and
authenticated. This is done automatically if you already have the Warp app installed.

Then, create an environment using one of the prebuilt images:

```bash
oz environment create --name my-go-env --docker-image warpdotdev/dev-go:1.23 --repo octocat/hello-world
```

After creating an environment, you can use it to:

- Run one-off or scheduled Oz agents from the CLI:

```bash
oz agent run-cloud --environment env_abc123 --prompt "Fix the failing tests in src/"
```

- Create integrations with Slack or Linear:

```bash
oz integration create slack --environment env_abc123
```

- Invoke agents programmatically via the
  [Agent API](https://docs.warp.dev/reference/api-and-sdk).

## Available Images

All images are based on Ubuntu. Language-specific images extend the base image with additional
runtimes.

- **warpdotdev/dev-base:latest** — Node 22 + Python 3
- **warpdotdev/dev-go:1.23** — Go 1.23.4 + base
- **warpdotdev/dev-rust:1.83** — Rust 1.83.0 + base
- **warpdotdev/dev-java:21** — Temurin JDK 21, Maven, Gradle + base
- **warpdotdev/dev-dotnet:8.0** — .NET SDK 8.0 + base
- **warpdotdev/dev-ruby:3.3** — Ruby 3.3 + Bundler + base
- **warpdotdev/dev-web:latest** — Google Chrome, Firefox + base

## Helpful Tips

- Use the `/create-environment` slash command in Warp for a guided setup flow that suggests the
  appropriate image for your project. See the
  [documentation](https://docs.warp.dev/agent-platform/cloud-agents/environments#create-an-environment-with-guided-setup-recommended)
  for more info.
- To use a custom image, you can call the `oz environment create` command with the `--docker-image` flag and the
  name of your image on DockerHub.

## Documentation

- [Oz Platform Overview](https://docs.warp.dev/agent-platform/cloud-agents/platform)
- [Oz Environments](https://docs.warp.dev/agent-platform/cloud-agents/environments)
- [Oz Agents](https://docs.warp.dev/agent-platform/cloud-agents/cloud-agents-overview)
- [Agent API & SDK](https://docs.warp.dev/reference/api-and-sdk)

