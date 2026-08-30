## Quick setup integration contract

The existing `clawmobile` quick setup can source `custom-openai-endpoint.sh` and call `clawmobile_configure_custom_openai_endpoint` after collecting `CLAWMOBILE_CUSTOM_PROVIDER_ID`, `CLAWMOBILE_CUSTOM_BASE_URL`, and `CLAWMOBILE_CUSTOM_MODEL_ID`.

This keeps the integration small and delegates all model/provider transport semantics to OpenClaw.
