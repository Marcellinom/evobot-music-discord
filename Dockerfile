FROM node:18.18.2-slim as base

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 build-essential && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r evobot && \
    useradd --create-home --home /home/evobot -r -g evobot evobot

USER evobot
WORKDIR /home/evobot

FROM base as build

COPY --chown=evobot:evobot  . .
RUN npm ci
RUN npm run build

RUN rm -rf node_modules && \
    npm ci --omit=dev

FROM node:18.18.2-slim as prod

COPY --chown=evobot:evobot package*.json ./
COPY --from=build --chown=evobot:evobot /home/evobot/node_modules ./node_modules
COPY --from=build --chown=evobot:evobot /home/evobot/dist ./dist

CMD [ "node", "./dist/index.js" ]