# Custom OpenAI-compatible endpoint

The Termux runtime can use an OpenAI-compatible provider by configuring OpenClaw's native provider schema.

Example configuration:

```bash
openclaw config set 'models.providers["my-provider"]' '{"baseUrl":"https://example.com/v1","api":"openai-completions","models":[{"id":"my-model","name":"my-model"}]}'
openclaw config set 'auth.profiles["my-provider:default"]' '{"provider":"my-provider","mode":"api_key"}'
openclaw config set 'agents.defaults.models["my-provider/my-model"]' '{"alias":"Custom"}'
openclaw config set agents.defaults.model.primary 'my-provider/my-model'
```

Set the provider credential through the OpenClaw environment/secret mechanism. Never commit API keys.

The custom endpoint must implement the OpenAI-compatible contract expected by OpenClaw. Use HTTPS for remote endpoints and keep private credentials out of logs.
