FROM node:alpine
COPY kafka-websockets-node/dist dist/
WORKDIR dist
RUN npm install
ENTRYPOINT ["npm","start"]
EXPOSE 3000