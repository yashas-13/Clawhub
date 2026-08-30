# Custom OpenAI-Compatible Endpoints

Clawhub now includes a Termux helper that configures an OpenAI-compatible custom endpoint through OpenClaw's native onboarding flow.

OpenClaw supports custom providers with `custom-api-key`, a custom base URL, model ID, provider ID, and compatibility mode. This implementation deliberately delegates provider configuration to OpenClaw instead of maintaining a second provider schema in Clawhub.

## Interactive setup

Run from a Clawhub checkout:

```bash
bash installer/termux-lite/clawmobile-custom-openai.sh
```

The helper asks for:

- provider ID
- base URL, for example `https://example.com/v1`
- model ID
- API key (optional for unauthenticated endpoints)
- compatibility (`openai`, `openai-responses`, or `anthropic`)

The helper stores an API key in `~/.openclaw/.env` with restrictive permissions and configures OpenClaw using secret-reference mode. Never commit that file.

## Scripted setup

All interactive values can be supplied through environment variables:

```bash
CLAWMOBILE_CUSTOM_PROVIDER_ID=my-provider \
CLAWMOBILE_CUSTOM_BASE_URL=https://example.com/v1 \
CLAWMOBILE_CUSTOM_MODEL_ID=my-model \
CLAWMOBILE_CUSTOM_API_KEY=... \
CLAWMOBILE_CUSTOM_COMPATIBILITY=openai \
bash installer/termux-lite/clawmobile-custom-openai.sh
```

For endpoints that expose OpenAI's Responses API instead of Chat Completions, use:

```bash
CLAWMOBILE_CUSTOM_COMPATIBILITY=openai-responses \
bash installer/termux-lite/clawmobile-custom-openai.sh
```

For an endpoint whose model is known to accept images but whose model ID does not match OpenClaw's built-in vision heuristics, set:

```bash
CLAWMOBILE_CUSTOM_IMAGE_INPUT=1 bash installer/termux-lite/clawmobile-custom-openai.sh
```

Use `CLAWMOBILE_CUSTOM_TEXT_INPUT=1` to force text-only metadata instead.

## Security

Treat custom endpoint API keys as production credentials. Do not place keys in source files, commits, issues, screenshots, or public logs. The helper uses OpenClaw's environment-backed secret reference mechanism rather than embedding the credential in the provider configuration.

## Upstream compatibility

This change is intentionally narrow: the ClawMobile Termux runtime owns Android/Termux integration, while OpenClaw owns model-provider configuration and request semantics. This keeps custom-provider behavior aligned with OpenClaw's supported onboarding contract.
