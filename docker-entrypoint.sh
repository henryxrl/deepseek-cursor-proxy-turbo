#!/bin/bash
# docker-entrypoint.sh — translate environment variables into CLI flags
set -euo pipefail

# Helper: append "--flag value" if the env var is set
flag_val() {
    local var_name="$1" flag="$2" val
    val="${!var_name:-}"
    if [ -n "${val}" ]; then
        echo "${flag}" "${val}"
    fi
}

# Helper: append "--flag" or "--no-flag" for boolean env vars
flag_bool() {
    local var_name="$1" flag="$2" val
    val="${!var_name:-}"
    case "${val}" in
        1|true|True|TRUE|yes|Yes|YES|on|On|ON)
            echo "${flag}" ;;
        0|false|False|FALSE|no|No|NO|off|Off|OFF)
            echo "--no-${flag#--}" ;;
    esac
}

# Build the argument array
args=()

# These two always make sense for Docker
args+=(--host "${PROXY_HOST:-0.0.0.0}")
args+=(--config "${PROXY_CONFIG:-/data/config.yaml}")

# Parse booleans
args+=($(flag_bool PROXY_NGROK           --ngrok))
args+=($(flag_bool PROXY_VERBOSE         --verbose))
args+=($(flag_bool PROXY_DISPLAY_REASONING --display-reasoning))
args+=($(flag_bool PROXY_COLLAPSIBLE_REASONING --collapsible-reasoning))
args+=($(flag_bool PROXY_CORS            --cors))

# Parse valued flags
args+=($(flag_val PROXY_PORT                    --port))
args+=($(flag_val PROXY_MODEL                   --model))
args+=($(flag_val PROXY_BASE_URL                --base-url))
args+=($(flag_val PROXY_THINKING                --thinking))
args+=($(flag_val PROXY_REASONING_EFFORT        --reasoning-effort))
args+=($(flag_val PROXY_REASONING_CONTENT_PATH  --reasoning-content-path))
args+=($(flag_val PROXY_NGROK_URL               --ngrok-url))
args+=($(flag_val PROXY_TRACE_DIR               --trace-dir))
args+=($(flag_val PROXY_REQUEST_TIMEOUT         --request-timeout))
args+=($(flag_val PROXY_MAX_REQUEST_BODY_BYTES  --max-request-body-bytes))
args+=($(flag_val PROXY_REASONING_CACHE_MAX_AGE_SECONDS --reasoning-cache-max-age-seconds))
args+=($(flag_val PROXY_REASONING_CACHE_MAX_ROWS --reasoning-cache-max-rows))
args+=($(flag_val PROXY_MISSING_REASONING_STRATEGY --missing-reasoning-strategy))
args+=($(flag_val PROXY_USER_MESSAGE_SUFFIX     --user-suffix))

exec deepseek-cursor-proxy "${args[@]}"
