#!/data/data/com.termux/files/usr/bin/bash
# Custom OpenAI-compatible provider helper.
# Source this file from the existing clawmobile setup script.

clawmobile_configure_custom_openai_endpoint() {
  local provider_id="$1"
  local base_url="$2"
  local model_id="$3"

  [ -n "$provider_id" ] && [ -n "$base_url" ] && [ -n "$model_id" ] || {
    echo "[lite] custom provider, base URL, and model are required" >&2
    return 2
  }

  case "$base_url" in
    http://*|https://*) ;;
    *) echo "[lite] custom base URL must start with http:// or https://" >&2; return 2 ;;
  esac

  openclaw config set "models.providers[\"$provider_id\"]" "{\"baseUrl\":\"$base_url\",\"api\":\"openai-completions\",\"models\":[{\"id\":\"$model_id\",\"name\":\"$model_id\"}]}" || return 1
  openclaw config set "auth.profiles[\"$provider_id:default\"]" "{\"provider\":\"$provider_id\",\"mode\":\"api_key\"}" || return 1
  openclaw config set "agents.defaults.models[\"$provider_id/$model_id\"]" '{"alias":"Custom"}' || return 1
  openclaw config set agents.defaults.model.primary "$provider_id/$model_id" || return 1
}
