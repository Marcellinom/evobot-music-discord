FROM node:21-slim

WORKDIR /usr/src/app

COPY . ./

RUN npm ci
RUN npm run build

ENTRYPOINT [ "node", "index.js" ]