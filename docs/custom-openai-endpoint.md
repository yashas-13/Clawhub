# Custom OpenAI-Compatible Endpoints

Clawhub can configure an OpenAI-compatible model endpoint during Termux quick setup.

A custom endpoint should expose an OpenAI-compatible API, normally with a `/v1` base path and a chat-completions-compatible interface.

## Interactive setup

Run:

```bash
clawmobile setup --quick
```

Choose **Custom OpenAI-compatible endpoint**, then provide:

- provider ID
- base URL, for example `https://example.com/v1`
- API key
- model ID

The API key is stored in `~/.openclaw/.env` only when you explicitly choose to persist it. The file is created with restrictive permissions and must never be committed.

## Environment variables

For scripted setup, use:

```bash
CLAWMOBILE_CUSTOM_PROVIDER_ID=my-provider \
CLAWMOBILE_CUSTOM_BASE_URL=https://example.com/v1 \
CLAWMOBILE_CUSTOM_MODEL_ID=my-model \
CLAWMOBILE_CUSTOM_API_KEY=... \
clawmobile setup --non-interactive --auth-choice custom-api-key
```

The setup writes the custom provider/model configuration through OpenClaw's native onboarding path rather than maintaining a second provider schema in Clawhub.

## Compatibility

This integration targets OpenAI-compatible endpoints. If an endpoint implements a different request/response contract, it should not be configured as an OpenAI-compatible provider without an adapter.

## Security

Treat custom endpoint API keys like production credentials. Do not put keys in source files, commits, issues, screenshots, or public logs. Prefer environment-backed secrets and private endpoints where possible.
