# GitHub Actions Runner

This is a Docker image for running GitHub Actions Runner on a server.

## Usage

### Docker

```bash
docker run -d \
  --name github-actions-runner \
  -e URL=https://github.com/actions/runner \
  -e TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \
  wpkpda/github-actions-runner:v1.0.0
```
