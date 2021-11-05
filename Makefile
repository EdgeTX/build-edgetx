.PHONY: opentx-dev opentx-builder

opentx-dev:
	docker build -t opentx-dev ./dev

opentx-builder:
	docker build -t opentx-dev ./builder
