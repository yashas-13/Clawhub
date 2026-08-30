#!/data/data/com.termux/files/usr/bin/bash

# Helper functions for configuring a custom OpenAI-compatible OpenClaw provider.
# Sourced by the Clawhub Termux wrapper.

configure_custom_endpoint() {
  local provider_id="${1:?provider id required}"
  local base_url="${2:?base URL required}"
  local model_id="${3:?model id required}"

  case "$base_url" in
    http://*|https://*) ;;
    *) echo "[lite] ERROR: custom base URL must use http:// or https://" >&2; return 2 ;;
  esac

  openclaw config set "models.providers[\"$provider_id\"]" "{\"baseUrl\":\"$base_url\",\"api\":\"openai-completions\",\"models\":[{\"id\":\"$model_id\",\"name\":\"$model_id\"}]}" || return 1
  openclaw config set "auth.profiles[\"$provider_id:default\"]" "{\"provider\":\"$provider_id\",\"mode\":\"api_key\"}" || return 1
  openclaw config set "agents.defaults.models[\"$provider_id/$model_id\"]" '{"alias":"Custom"}' || return 1
  openclaw config set agents.defaults.model.primary "$provider_id/$model_id" || return 1
}
