FROM node:8-alpine
COPY node-demo/index.js node-demo/package.json dist/
WORKDIR dist/
RUN npm install
CMD npm start
EXPOSE 3000
