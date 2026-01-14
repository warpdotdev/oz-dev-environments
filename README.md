# Warp Dev Environment Docker Images

This repository contains prebuilt Docker images for use with Warp
[Environments](https://docs.warp.dev/platform/environments). These images provide ready-to-use
development environments for running [Ambient Agents](https://docs.warp.dev/ambient-agents/ambient-agents-overview)
and [CLI integrations](https://docs.warp.dev/platform/agent-api-and-sdk).

## Quickstart

To get started, you'll need to have the [Warp CLI](https://docs.warp.dev/developers/cli) installed and
authenticated. This is done automatically if you already have the Warp app installed.

Then, create an environment using one of the prebuilt images:

```bash
warp environment create --name my-go-env --docker-image warpdotdev/dev-go:1.23 --repo octocat/hello-world
```

After creating an environment, you can use it to:

- Run one-off or scheduled ambient agents from the CLI:

```bash
warp agent run-ambient --environment env_abc123 --prompt "Fix the failing tests in src/"
```

- Create integrations with Slack or Linear:

```bash
warp integration create slack --environment env_abc123
```

- Invoke agents programmatically via the
  [Agent API](https://docs.warp.dev/platform/agent-api-and-sdk#agent-api).

## Available Images

All images are based on Ubuntu. Language-specific images extend the base image with additional
runtimes.

- **warpdotdev/dev-base:1** — Node 22 + Python 3
- **warpdotdev/dev-go:1.23** — Go 1.23.4 + base
- **warpdotdev/dev-rust:1.83** — Rust 1.83.0 + base
- **warpdotdev/dev-java:21** — Temurin JDK 21, Maven, Gradle + base
- **warpdotdev/dev-dotnet:8.0** — .NET SDK 8.0 + base
- **warpdotdev/dev-ruby:3.3** — Ruby 3.3 + Bundler + base

## Helpful Tips

- Use the `/create-environment` slash command in Warp for a guided setup flow that suggests the
  appropriate image for your project. See the
  [documentation](https://docs.warp.dev/platform/environments#create-an-environment-with-guided-setup-recommended)
  for more info.
- To use a custom image, you can call the warp environment create command with the `--docker-image` flag and the
  name of your image on DockerHub.

## Documentation

- [Warp Platform Overview](https://docs.warp.dev/platform/warp-platform)
- [Environments](https://docs.warp.dev/platform/environments)
- [Ambient Agents](https://docs.warp.dev/ambient-agents/ambient-agents-overview)
- [Agent API & SDK](https://docs.warp.dev/platform/agent-api-and-sdk)

