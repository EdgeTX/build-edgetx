.PHONY: edgetx-dev edgetx-builder

edgetx-dev:
	docker build -t edgetx-dev ./dev

edgetx-builder:
	docker build -t edgetx-builder ./builder
