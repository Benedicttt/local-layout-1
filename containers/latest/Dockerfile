FROM application:base

USER root

RUN curl --silent --location https://deb.nodesource.com/setup_10.x | bash - \
    && apt update \
    && apt install -y -q nodejs \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app

COPY package.json /app

RUN npm i < ./package.json

USER seluser

