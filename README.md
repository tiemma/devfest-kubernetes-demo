# DevFest Kubernetes Demo

This repo contains details about how to manage an application on Kubernetes illustrating the following features:
 - Containerization
 - Orchestration of deploying containers
 - Service exposure for external access
 - Ingress setup for domain name mapping
 - Namespacing for implementing deployment strategies (Blue/Green, Canary etc.)
 - Default 404 route handling 
 - External environment configurations using ConfigMaps
 - Load Balancing of multiple container deployments
 - Automatic restarts of failed pods during runtime and fault handling for high availability

 > *TLDR:* If you don't wanna start reading the long docs, run
 ```bash
make run
 ```


## Breakdown of folder and file structures


### [Node Demo Application](node-demo)
---

 The application is a simple node application that hosts a simple server which returns random numbers.
Within the project, there exists a snippet which breaks our application when the generated random number is greater than a certain limit

```javascript
  requestRandomNumber = Math.floor(Math.random() * 255)
  if (requestRandomNumber > 150) {
    //Let's purposefully break our app
    res.send({ error: true, random: randomNumber }).status(500)
    process.emit('SIGINT');
  } else {
    res.send(`
    Random number for this pod is: + ${randomNumber}. 
    <br \>
    You env variable with property key is: ${process.env.KEY}
    `);
  }
```

The SIGINT would force that instance of our application to break and we'd see this in the deployment status. Kubernetes would then restart this pod and we'd see it back up again with no assistance.

There's also a small websocket setup for showing how to stream error logs and handle failures in your application.


### [Dockerfile](Dockerfile)
---

This is a basic Dockerfile setup for which our node application will run in.
We just install the dependencies and expose the port locally.

```docker
#Always an alpine image to make sure your image size is small
FROM node:8-alpine

#Copy in our application data to the dist folder
COPY node-demo/index.js node-demo/package.json node-demo/index.html dist/
WORKDIR dist/

#Install dependencies and start the server afterwards
RUN npm install
CMD npm start

#We expose the port we're running our application on
EXPOSE 3000
```

If you don't have docker installed, you can run this:

> sudo bash [set-up-docker.sh](set-up-docker.sh)


### Kubernetes Configuration
---

 All these files start with the "*kubernetes-*" prefix for ease of accessibility.

You can go through the configuration defined there and apply it using the following configuration

> make deploy-k8s-config

If you edit any of the configuration files, you can apply the changes using:

> make update


### [Makefile](Makefile) usage
---

There exists a make file to abstract all the unncessary details in the bash file where various functions for installing and updating deployment configurations are defined.

You can view the available commands by typing in:
> make 

A PHONY command has been defined to handle commands not defined and this would display the list of available commands you can type in.  


### Shell scripts
---

I wrote two scripts to enable new users install the  dependencies easily, if you plan to develop more.

Local Docker Setup [!NOT REQUIRED FOR THE DEMO]
---
All docker installation steps are defined here: [set-up-docker.sh](set-up-docker.sh)

This install docker on your system. It's not really needed for the demo as the Kubernetes cluster already comes with docker installed locally in its VM environment. This is just here to assist individuals who want to try out docker on their own and run the project before deploying it to Kubernetes.

Once you've run the bash file, 

> bash set-up-docker.sh

Then, proceed to run the [Dockerfile](Dockerfile) locally. It will download all the dependencies and you'd be able to access it afterwards

```bash
# Build the docker image using the docker file here
# and give it a tag name of node-demo
docker build -t node-demo .

# Now, we can start the container using the tag name we just defined
docker run -it -p 3000:3000  node-demo
```


Overall kubernetes and minikube configuration setup 
---
The file responsible for this is available here:  [set-up-env-minikube.sh](set-up-env-minikube.sh)

This is where all the heavy lifting is done and most of the functions simply defined in the make file are used.

You can go through the file to see examples of the bash scripting to install minikube and set up the environment on its own without much setup time and browsing.


For an overall setup that'll build everything for you and run over the tutorial, use the command below:

> make run

Thanks for reading, DevFest Lagos 2018.

Also follow me on Twitter here(twitter.com/TiemmaBakare)