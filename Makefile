install: 
	bash set-up-env-minikube.sh install-minikube-and-start

run: install-minikube

delete: 
	delete

enable-ingress: 
	enable-addons

build-image: 
	build-image

deploy-config: 
	deploy

add-host: 
	add-to-hosts

.PHONY: list

list:
    @$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs	