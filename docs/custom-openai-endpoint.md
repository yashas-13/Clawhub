# Custom OpenAI-Compatible Endpoints

Clawhub includes a Termux helper that configures an OpenAI-compatible custom endpoint through OpenClaw's native onboarding flow.

OpenClaw supports custom providers with a custom base URL, model ID, provider ID, API key, and compatibility mode. Clawhub delegates those settings to OpenClaw instead of maintaining a second provider schema.

## Interactive setup

From a Clawhub checkout:

```bash
bash installer/termux-lite/clawmobile-custom-openai.sh
```

The helper asks for:

- provider ID
- base URL, for example `https://example.com/v1`
- model ID
- API key (optional for unauthenticated endpoints)
- compatibility: `openai`, `openai-responses`, or `anthropic`

When a key is supplied, the helper stores it in `~/.openclaw/.env` with restrictive permissions and uses OpenClaw's environment-backed secret-reference mode. Never commit that file.

## Scripted setup

```bash
CLAWMOBILE_CUSTOM_PROVIDER_ID=my-provider \
CLAWMOBILE_CUSTOM_BASE_URL=https://example.com/v1 \
CLAWMOBILE_CUSTOM_MODEL_ID=my-model \
CLAWMOBILE_CUSTOM_API_KEY=... \
CLAWMOBILE_CUSTOM_COMPATIBILITY=openai \
bash installer/termux-lite/clawmobile-custom-openai.sh
```

For an endpoint that supports OpenAI Responses rather than Chat Completions:

```bash
CLAWMOBILE_CUSTOM_COMPATIBILITY=openai-responses \
bash installer/termux-lite/clawmobile-custom-openai.sh
```

For a custom vision model whose ID is not recognized by OpenClaw's vision heuristics:

```bash
CLAWMOBILE_CUSTOM_IMAGE_INPUT=1 bash installer/termux-lite/clawmobile-custom-openai.sh
```

Use `CLAWMOBILE_CUSTOM_TEXT_INPUT=1` to force text-only metadata.

## Security

Treat custom endpoint API keys as production credentials. Do not put keys in source files, commits, issues, screenshots, or public logs. Prefer environment-backed secrets and private endpoints where possible.

## Scope

This contribution is intentionally narrow: Clawhub owns the Termux/Android integration while OpenClaw owns model-provider configuration and request semantics. This keeps custom-provider behavior aligned with OpenClaw's supported onboarding contract.
