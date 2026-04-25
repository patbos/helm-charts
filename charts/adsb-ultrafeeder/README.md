# adsb-ultrafeeder

## ADSB Exchange Example

Set your real location, altitude, UUID, and MLAT username before installing.

```yaml
timezone: Europe/Amsterdam

location:
  latitude: "52.0000"
  longitude: "5.0000"
  altitude: "15m"

ultrafeeder:
  uuid: "00000000-0000-0000-0000-000000000000"
  mlatUser: your-station-name
  config: "adsb,feed1.adsbexchange.com,30004,beast_reduce_plus_out;mlat,feed.adsbexchange.com,31090"
```

To disable ADSB Exchange statistics sharing, add:

```yaml
extraEnv:
  - name: ADSBX_STATS
    value: disabled
```

## Prometheus Example

Enable the container's Telegraf Prometheus endpoint and create a Prometheus Operator `ServiceMonitor` for both metrics ports:

```yaml
prometheus:
  enabled: true
  serviceMonitor:
    enabled: true
    interval: 30s
```

## RTL-SDR Example

Mount the node's USB bus and run the container privileged so readsb can access an RTL-SDR device:

```yaml
readsb:
  deviceType: rtlsdr
  rtlsdrDevice: "00001000"

usb:
  enabled: true

securityContext:
  privileged: true
```
