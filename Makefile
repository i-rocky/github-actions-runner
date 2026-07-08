VERSION = v1.2.2
IMAGE = wpkpda/github-actions-runner

build:
	docker buildx build --builder default -t $(IMAGE):$(VERSION) .

push:
	docker buildx build --builder default --push --platform linux/amd64 -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

.PHONY: build push
