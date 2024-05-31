FROM node:21-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci
RUN npm run build

COPY . ./

ENTRYPOINT [ "node", "index.js" ]