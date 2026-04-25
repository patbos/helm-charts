#!/usr/bin/env bash
set -euo pipefail

repo="${GITHUB_REPOSITORY:-patbos/helm-charts}"
owner="${repo%%/*}"
registry_owner="${owner,,}"
destination="oci://ghcr.io/${registry_owner}/helm-charts"
workdir="${TMPDIR:-/tmp}/helm-oci-backfill"

mkdir -p "$workdir"

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "GITHUB_TOKEN must be set to a token with packages:write permission" >&2
  exit 1
fi

echo "$GITHUB_TOKEN" | helm registry login ghcr.io \
  --username "$owner" \
  --password-stdin

gh release list --repo "$repo" --limit 1000 --json tagName -q '.[].tagName' |
while read -r tag; do
  [[ -n "$tag" ]] || continue

  echo "Downloading chart packages from release $tag"
  gh release download "$tag" \
    --repo "$repo" \
    --pattern '*.tgz' \
    --dir "$workdir" \
    --clobber
done

shopt -s nullglob
packages=("$workdir"/*.tgz)
if [[ ${#packages[@]} -eq 0 ]]; then
  echo "No chart packages found in GitHub releases" >&2
  exit 1
fi

for package in "${packages[@]}"; do
  echo "Pushing $package to $destination"
  helm push "$package" "$destination"
done
