# Helm charts

## TL;DR

    helm repo add patbos https://helm.patbos.com
    helm repo update

## OCI charts

Charts are also published to GitHub Container Registry as OCI artifacts.

    helm install <release-name> oci://ghcr.io/patbos/helm-charts/<chart-name> --version <chart-version>

Example:

    helm install adsb-ultrafeeder oci://ghcr.io/patbos/helm-charts/adsb-ultrafeeder --version 1.0.1
