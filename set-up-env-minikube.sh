#!/bin/bash

MINIKUBE_IP=$(minikube ip)

start(){
    minikube start
}

run(){
    start
    delete
    enable_addons
    build_image
    deploy
    open_service
}

install-minikube-and-start() {
    if hash minikube 2>/dev/null; then
        run
    else
        curl -L https://github.com/kubernetes/minikube/releases/download/v0.28.0/minikube-linux-amd64 -c -x 10 -s 10 -j 10 -o /tmp/minikube
        sudo chmod +x /tmp/minikube
        #Just incase local/bin is not in your path
        export PATH=$PATH:$HOME/.local/bin
        cp /tmp/minikube ~/.local/bin/minikube
        run
    fi
}

echo_with_decorators(){
    echo -e "\n >----- \n  $1 \n ------<\n"
    echo "Press enter when ready to continue"
    read

}

delete(){
    echo_with_decorators "Deleting previous namespaces if they exist"
    kubectl delete namespace random-namespace
}

enable_addons(){
    echo_with_decorators "Enabling ingress setup to allow local load balancer use"
    minikube addons enable ingress
}

build_image(){
    #We need to switch over to the minikube docker client
    echo_with_decorators "Here we want to make sure that our docker builds go to kubernetes so we switch docker clients"
    DOCKER_SETUP_K8S=$(minikube docker-env)
    echo_with_decorators "Here's what makes that happen:"
    echo_with_decorators "$DOCKER_SETUP_K8S"
    eval $DOCKER_SETUP_K8S

    echo_with_decorators "Now we're gonna build the test node-demo app"
    docker build -t node-demo .
}

deploy(){
    echo_with_decorators "Now we run through all the config files we have in the order specified"
    echo_with_decorators "namespace,config,deployment,service,ingress"
    for f in *{namespace,config,deployment,service,ingress}*; do kubectl create -f  $f; done 
}

add_to_hosts(){
    echo_with_decorators "Adding minikube ip to hosts file"
    if cat /etc/hosts | grep random.demo 2> /dev/null; then
        echo_with_decorators "You already have it in your hosts file"
    else
        echo_with_decorators "Adding minikube host IP to your computer"
        echo_with_decorators "$MINIKUBE_IP random.demo" | sudo tee -a /etc/hosts
    fi
}

open_service(){
    echo_with_decorators "You can also choose to open the service after all has been configured using this"
    minikube service random-service --namespace=random-service
}

if [[ -z "$1" ]]; then
    echo_with_decorators "Kindly use the Makefile to access commands here, Thanks :-)"
else
    "$@"
fi