FROM ruby:2.5.1-alpine

WORKDIR /opt/app/
COPY . /opt/app/

RUN apk add --no-cache bash postgresql-dev postgresql-client openssh build-base git make nodejs sqlite sqlite-dev imagemagick tzdata
RUN gem uninstall -aIx
RUN gem install bundler 
RUN RAILS_ENV=test bundle install --jobs 2
RUN gem install nokogiri 
RUN gem install pry \
                pry-byebug \
                pry-doc \
                pry-git \
                pry-rails \
                pry-remote 
CMD [ "tail", "-f", "/dev/null" ]
