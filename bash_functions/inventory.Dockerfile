FROM mobingi/ubuntu-nginx-ruby:ruby-2.4

RUN mkdir -pv /opt/app
RUN apt update && apt install -y nodejs nginx nano

WORKDIR /opt/app

COPY Gemfile* /opt/app/
RUN /bin/sh -c bundle install
RUN gem install pry \
                pry-byebug \
                pry-doc \
                pry-git \
                pry-rails \
                pry-remote 
COPY . /opt/app/

CMD [ "tail", "-f", "/dev/null" ]