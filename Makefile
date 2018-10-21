SHELL := /bin/bash 

.PHONY: list

list:
	echo -e "\n\nSpecify a command: install-and-run, run, delete-namespace, enable-ingress, build-image, deploy-k8s-config, add-hosts"

install-and-run: 
	bash set-up-env-minikube.sh install_and_start

run: install-and-run

update:
	bash set-up-env-minikube.sh update_configs

delete-namespace: 
	bash set-up-env-minikube.sh delete

enable-ingress: 
	bash set-up-env-minikube.sh enable_addons

build-image: 
	bash set-up-env-minikube.sh build_image

deploy-k8s-config: 
	bash set-up-env-minikube.sh deploy

add-hosts: 
	bash set-up-env-minikube.sh add_to_hosts