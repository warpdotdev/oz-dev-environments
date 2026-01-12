# Warp Dev Environment Docker Images

Prebuilt dev environments for use with Warp's Ambient Agents and CLI integrations. See docs:
- https://docs.warp.dev/platform/warp-platform
- https://docs.warp.dev/platform/environments

## Images
All images are Ubuntu; non-base = base (Node+Python) + language runtime.

| Image | Tag | Includes |
|---|---|---|
| warpdotdev/dev-base | 1 | Node 22 + Python 3 |
| warpdotdev/dev-go | 1.23 | Go 1.23.4 + base |
| warpdotdev/dev-rust | 1.83 | Rust 1.83.0 + base |
| warpdotdev/dev-java | 21 | Temurin JDK 21, Maven, Gradle + base |
| warpdotdev/dev-dotnet | 8.0 |.NET SDK 8.0 + base |
| warpdotdev/dev-ruby | 3.3 | Ruby 3.3 + Bundler + base |

## Quick Start
Run the following command with the Warp CLI to set up an environment:
```bash
warp environment create --name my-env --docker-image warpdotdev/dev-go:1.23 --repo your/repo
```

After creating an envrionment, you can use it:

- In [integrations](https://docs.warp.dev/platform/agent-api-and-sdk#agent-api)
```bash
warp integration create <slack/linear> --environment <environment_id>
```

- To run one-off or scheduled [ambient agents](https://docs.warp.dev/ambient-agents/ambient-agents-overview) from the CLI
```bash
warp agent run-ambient --environment <environment_id> --prompt <prompt>
```

- With our [API](https://docs.warp.dev/platform/agent-api-and-sdk#agent-api)

