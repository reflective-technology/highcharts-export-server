FROM dhi.io/node:24.14.0-debian12-dev AS base
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable
RUN apt update && \
    apt install fonts-noto-cjk wget -y && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt upgrade -y && \
    apt install ./google-chrome-stable_current_amd64.deb -y && \
    apt autoclean && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm google-chrome-stable_current_amd64.deb && \
    mkdir -p /app && \
    chown -R node:node /app
USER node
WORKDIR /app
COPY config.json chart-config.json package.json pnpm-lock.yaml /app/
RUN pnpm install --frozen-lockfile && \
    pnpm highcharts-export-server --noLogo true --infile chart-config.json --type png --loadConfig config.json

FROM base AS dev
ENV OTHER_NO_LOGO=true SERVER_ENABLE=true SERVER_PORT=8080
ENTRYPOINT ["pnpm", "highcharts-export-server", "--loadConfig", "config.json"]

FROM base AS prod
ENV LOGGING_LEVEL=2 OTHER_NO_LOGO=true SERVER_ENABLE=true SERVER_PORT=8080
ENTRYPOINT ["pnpm", "highcharts-export-server", "--loadConfig", "config.json"]