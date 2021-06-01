#!/usr/bin/env bash

SCRIPTS_PATH="/valhalla/scripts"
CUSTOM_FILES="/custom_files"
CONFIG_FILE="${CUSTOM_FILES}/valhalla.json"

echo "========================================================================="
echo "== Start configuration and data generation without starting the server =="
echo "========================================================================="

/bin/bash /valhalla/scripts/configure_valhalla.sh ${SCRIPTS_PATH} ${CONFIG_FILE} ${CUSTOM_FILES} "${tile_urls}" "${min_x}" "${max_x}" "${min_y}" "${max_y}" "${build_elevation}" "${build_admins}" "${build_time_zones}" "${force_rebuild}" "${force_rebuild_elevation}" "${use_tiles_ignore_pbf}"
