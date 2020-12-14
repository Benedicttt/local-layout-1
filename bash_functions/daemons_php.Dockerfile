FROM php:7.3-rc as builder

RUN mkdir -pv /opt/app
RUN apt update && apt install -y nodejs
RUN apt-get install -y procps 

WORKDIR /opt/app

COPY . /opt/app/

CMD [ "tail", "-f", "/dev/null" ]