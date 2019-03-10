FROM node:8.15.0

# Install VS Code's deps. These are the only two it seems we need.
RUN apt-get update && apt-get install -y \
  libxkbfile-dev \
  libsecret-1-dev

# Ensure latest yarn.
RUN npm install -g yarn@1.13

WORKDIR /src
COPY . .

RUN yarn && yarn task build:server:binary

FROM stemn/development-environment:latest
COPY --from=0 /src/packages/server/cli-linux-x64 /usr/local/bin/code-server
EXPOSE 8443
ENTRYPOINT code-server
CMD code-server $PWD
