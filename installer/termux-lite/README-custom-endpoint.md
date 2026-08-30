# Custom OpenAI-compatible endpoint

Clawhub's Termux runtime can be configured against an OpenAI-compatible API without adding a provider-specific HTTP client. OpenClaw owns provider routing and authentication.

For a provider named `my-provider` and model `my-model`:

```bash
openclaw config set 'models.providers["my-provider"]' '{"baseUrl":"https://example.com/v1","api":"openai-completions","models":[{"id":"my-model","name":"my-model"}]}'
openclaw config set 'auth.profiles["my-provider:default"]' '{"provider":"my-provider","mode":"api_key"}'
openclaw config set 'agents.defaults.models["my-provider/my-model"]' '{"alias":"Custom"}'
openclaw config set agents.defaults.model.primary 'my-provider/my-model'
```

Store the provider credential using OpenClaw's supported environment/secret mechanism. Never commit API keys or expose them in logs.

The endpoint must implement the OpenAI-compatible contract expected by OpenClaw. Prefer HTTPS for remote endpoints.
