## Implementation design

The custom endpoint feature should be implemented in the existing `clawmobile` quick-setup flow. It should collect a provider id, OpenAI-compatible base URL, model id, and API key, then delegate provider configuration to OpenClaw. The key must be stored through the existing `~/.openclaw/.env` mechanism with mode 0600 when persistence is explicitly requested.

The endpoint is expected to use the OpenAI completions transport. Do not add a separate HTTP client or duplicate OpenClaw's provider schema.
