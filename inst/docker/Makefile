.PHONY: all
all: make-image push

.PHONY: base
base:
	docker build -t chronicler-base -f Dockerfile.base .

.PHONY: make-image
make-image: base
	docker build -t chronicler -f Dockerfile .

# https://ropenscilabs.github.io/r-docker-tutorial/04-Dockerhub.html
.PHONY: push
push: make-image
	docker tag $$(docker images -q chronicler-base:latest) lbartnik/chronicler-base:18.10
	docker push lbartnik/chronicler-base
	docker tag $$(docker images -q chronicler:latest) lbartnik/chronicler:18.10
	docker push lbartnik/chronicler

