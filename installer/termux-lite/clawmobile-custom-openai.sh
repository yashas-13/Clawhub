#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

clawmobile_require_termux
clawmobile_lite_env
clawmobile_require_openclaw

prompt() {
  local label="$1"
  local default="${2:-}"
  local value=""
  if [ -n "$default" ]; then
    printf '%s [%s]: ' "$label" "$default" >&2
  else
    printf '%s: ' "$label" >&2
  fi
  IFS= read -r value
  printf '%s' "${value:-$default}"
}

prompt_secret() {
  local label="$1"
  local value=""
  printf '%s (input hidden; paste, then press Enter): ' "$label" >&2
  IFS= read -r -s value || true
  printf '\n' >&2
  value="${value//$'\r'/}"
  value="$(printf '%s' "$value" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
  printf '%s' "$value"
}

upsert_env_var() {
  local name="$1"
  local value="$2"
  local env_file="${OPENCLAW_ENV_FILE:-$HOME/.openclaw/.env}"
  local tmp_file=""

  mkdir -p "$(dirname "$env_file")"
  touch "$env_file"
  chmod 600 "$env_file" 2>/dev/null || true
  tmp_file="$(mktemp "${TMPDIR:-/tmp}/clawmobile-custom-env.XXXXXX")"
  grep -v "^${name}=" "$env_file" > "$tmp_file" 2>/dev/null || true
  printf '%s=%s\n' "$name" "$value" >> "$tmp_file"
  cat "$tmp_file" > "$env_file"
  rm -f "$tmp_file"
  export "$name=$value"
}

normalize_base_url() {
  local url="$1"
  url="${url%/}"
  case "$url" in
    http://*|https://*) printf '%s' "$url" ;;
    *) return 1 ;;
  esac
}

base_url="${CLAWMOBILE_CUSTOM_BASE_URL:-}"
provider_id="${CLAWMOBILE_CUSTOM_PROVIDER_ID:-}"
model_id="${CLAWMOBILE_CUSTOM_MODEL_ID:-}"
api_key="${CLAWMOBILE_CUSTOM_API_KEY:-${CUSTOM_API_KEY:-}}"
compatibility="${CLAWMOBILE_CUSTOM_COMPATIBILITY:-openai}"

if [ -z "$base_url" ]; then
  base_url="$(prompt 'Custom endpoint base URL (for example https://llm.example.com/v1)')"
fi
base_url="$(normalize_base_url "$base_url")" || {
  echo "[clawmobile] ERROR: base URL must start with http:// or https://" >&2
  exit 2
}

if [ -z "$model_id" ]; then
  model_id="$(prompt 'Model ID')"
fi
[ -n "$model_id" ] || { echo "[clawmobile] ERROR: model ID is required" >&2; exit 2; }

if [ -z "$provider_id" ]; then
  provider_id="$(prompt 'Provider ID' 'custom')"
fi
case "$provider_id" in
  *[!A-Za-z0-9._-]*|'')
    echo "[clawmobile] ERROR: provider ID may contain only letters, numbers, '.', '_' and '-'" >&2
    exit 2
    ;;
esac

case "$compatibility" in
  openai|openai-responses|anthropic) ;;
  *)
    echo "[clawmobile] ERROR: compatibility must be openai, openai-responses, or anthropic" >&2
    exit 2
    ;;
esac

if [ -z "$api_key" ]; then
  api_key="$(prompt_secret 'API key (leave blank if endpoint requires no key)')"
fi

if [ -n "$api_key" ]; then
  # OpenClaw ref-mode requires CUSTOM_API_KEY to be present in the onboarding
  # environment. Persist it with 0600 permissions so future gateway starts can
  # resolve the reference without placing the secret in the OpenClaw config.
  upsert_env_var "CUSTOM_API_KEY" "$api_key"
fi

args=(
  --non-interactive
  --accept-risk
  --skip-health
  --mode local
  --auth-choice custom-api-key
  --custom-base-url "$base_url"
  --custom-model-id "$model_id"
  --custom-provider-id "$provider_id"
  --custom-compatibility "$compatibility"
  --secret-input-mode ref
)

if [ -n "$api_key" ]; then
  args+=(--custom-api-key "$api_key")
fi

if [ "${CLAWMOBILE_CUSTOM_IMAGE_INPUT:-0}" = "1" ]; then
  args+=(--custom-image-input)
elif [ "${CLAWMOBILE_CUSTOM_TEXT_INPUT:-0}" = "1" ]; then
  args+=(--custom-text-input)
fi

echo "[clawmobile] Configuring custom provider '$provider_id' with model '$model_id'"
echo "[clawmobile] Endpoint: $base_url"
echo "[clawmobile] Compatibility: $compatibility"

exec openclaw onboard "${args[@]}"
