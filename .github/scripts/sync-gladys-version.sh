#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_FILE="${ROOT_DIR}/gladys/config.yaml"
BUILD_FILE="${ROOT_DIR}/gladys/build.yaml"
CHANGELOG_FILE="${ROOT_DIR}/gladys/CHANGELOG.md"
DOCKERFILE="${ROOT_DIR}/gladys/Dockerfile"

latest_tag="$(
  curl -fsSL "https://api.github.com/repos/GladysAssistant/Gladys/releases/latest" \
    | jq -r '.tag_name'
)"

if [[ -z "${latest_tag}" || "${latest_tag}" == "null" ]]; then
  echo "Failed to fetch latest Gladys release tag."
  exit 1
fi

gladys_version="${latest_tag#v}"
docker_tag="v${gladys_version}"
docker_image="gladysassistant/gladys:${docker_tag}"

docker_status="$(
  curl -fsSL -o /dev/null -w "%{http_code}" \
    "https://hub.docker.com/v2/repositories/gladysassistant/gladys/tags/${docker_tag}"
)"

if [[ "${docker_status}" != "200" ]]; then
  echo "Docker image ${docker_image} is not available yet (HTTP ${docker_status}). Skipping."
  exit 0
fi

current_version="$(
  grep '^version:' "${CONFIG_FILE}" | sed -E 's/^version: "(.*)"/\1/'
)"

if [[ "${current_version}" == "${gladys_version}" ]]; then
  echo "Add-on already at Gladys version ${gladys_version}."
  exit 0
fi

echo "Updating add-on from ${current_version} to ${gladys_version} (${docker_image})."

sed -i "s/^version: \".*\"/version: \"${gladys_version}\"/" "${CONFIG_FILE}"

sed -i "s|gladysassistant/gladys:v[^\"]*|${docker_image}|g" "${BUILD_FILE}"

sed -i "s|^ARG BUILD_FROM=gladysassistant/gladys:v.*|ARG BUILD_FROM=${docker_image}|" "${DOCKERFILE}"

{
  echo "# Changelog"
  echo ""
  echo "## ${gladys_version}"
  echo ""
  echo "- Update Gladys Assistant to v${gladys_version}"
  echo ""
  tail -n +3 "${CHANGELOG_FILE}"
} > "${CHANGELOG_FILE}.tmp"
mv "${CHANGELOG_FILE}.tmp" "${CHANGELOG_FILE}"

git -C "${ROOT_DIR}" add "${CONFIG_FILE}" "${BUILD_FILE}" "${DOCKERFILE}" "${CHANGELOG_FILE}"

if git -C "${ROOT_DIR}" diff --staged --quiet; then
  echo "No file changes detected after update."
  exit 0
fi

git -C "${ROOT_DIR}" commit -m "$(cat <<EOF
chore: update Gladys Assistant to v${gladys_version}

Sync add-on version with the latest Gladys release.
EOF
)"
