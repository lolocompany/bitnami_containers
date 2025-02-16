#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Grafana environment
. /opt/bitnami/scripts/grafana-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

declare cmd="grafana-server"
declare -a args=(
    # Based on https://github.com/grafana/grafana/blob/v8.2.5/packaging/docker/run.sh
    "--homepath=${GF_PATHS_HOME}"
    "--config=${GF_PATHS_CONFIG}"
    "--pidfile=${GRAFANA_PID_FILE}"
    "--packaging=docker"
    "$@"
    "cfg:default.log.mode=console"
    "cfg:default.paths.data=${GF_PATHS_DATA}"
    "cfg:default.paths.logs=${GF_PATHS_LOGS}"
    "cfg:default.paths.plugins=${GF_PATHS_PLUGINS}"
    "cfg:default.paths.provisioning=${GF_PATHS_PROVISIONING}"
)

cd "$GRAFANA_BASE_DIR"

info "** Starting Grafana **"
if am_i_root; then
    exec gosu "$GRAFANA_DAEMON_USER" "$cmd" "${args[@]}"
else
    exec "$cmd" "${args[@]}"
fi
