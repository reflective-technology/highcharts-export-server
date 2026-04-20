FROM dhi.io/node:24.15.0-sfw-dev AS base
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable
RUN apt-get update && \
    apt-get -y -o DPkg::Options::="--force-confnew" upgrade && \
    apt-get install fonts-noto-cjk=1:20240730+repack1-1 wget=1.25.0-2 -y --no-install-recommends && \
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install ./google-chrome-stable_current_amd64.deb -y --no-install-recommends && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm google-chrome-stable_current_amd64.deb && \
    mkdir -p /app && \
    chown -R node:node /app
USER node
WORKDIR /app
COPY config.json chart-config.json package.json package-lock.json /app/
RUN npm ci && \
    npx highcharts-export-server --noLogo true --infile chart-config.json --type png --loadConfig config.json

FROM base AS dev
ENV OTHER_NO_LOGO=true SERVER_ENABLE=true SERVER_PORT=8080
ENTRYPOINT ["npx", "highcharts-export-server", "--loadConfig", "config.json"]

FROM base AS prod
ENV LOGGING_LEVEL=2 OTHER_NO_LOGO=true SERVER_ENABLE=true SERVER_PORT=8080
ENTRYPOINT ["npx", "highcharts-export-server", "--loadConfig", "config.json"]