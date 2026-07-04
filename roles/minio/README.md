# minio role

Installs MinIO and shows the API and console URLs in the final summary.

## What it does

- deploys MinIO in Docker or Kubernetes
- exposes the S3 API and web console separately
- supports separate API and console hostnames in domain mode
- supports persistent storage with a Docker bind mount or Kubernetes PVC

## Main settings

- `minio: true`
- `global_deploy_mode: docker | k8s`
- `minio_image`
- `minio_api_port`
- `minio_console_port`
- `minio_api_domain`
- `minio_console_domain`
- `minio_root_user`
- `minio_root_password`
- `use_domain`

## Use

In this repo, turn it on in `config.yaml`:

```yaml
minio: true
```

Then run:

```bash
just run
```

Kubernetes note:

- IP testing uses NodePorts `30910` for the API and `30911` for the console by default
- domain mode uses two hostnames: one for the API and one for the console
