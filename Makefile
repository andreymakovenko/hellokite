VERSION := $(shell cat VERSION)
IMAGE   := gcr.io/helios-devel/andrey-hellokite:$(VERSION)

default: build run

build:
	@echo '> Building "andrey-hellokite" docker image...'
	@docker build -t $(IMAGE) .

push:

	gcloud docker -- push $(IMAGE)


run:
	@echo '> Starting "andrey-hellokite" container...'
	@docker run -d $(IMAGE)

ci:
	@fly -t ci set-pipeline -p andrey-hellokite -c config/pipelines/review.yml --load-vars-from config/pipelines/secrets.yml -n
	@fly -t ci unpause-pipeline -p andrey-hellokite

deploy:
	@helm install ./config/charts/andrey-hellokite --set "image.tag=$(VERSION)"
