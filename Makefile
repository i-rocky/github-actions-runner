build:
	docker build -t wpkpda/github-actions-runner:v1.0.0 .

push:
	docker buildx build --push --platform linux/amd64 -t wpkpda/github-actions-runner:v1.0.0 .

.PHONY: build push
