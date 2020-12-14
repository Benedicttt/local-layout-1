FROM ruby:2.5.1-alpine

RUN mkdir -pv /opt/app
ENV LANG C.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /opt/app/
COPY . /opt/app/

RUN apk add --no-cache bash nano less cmake nodejs postgresql-dev postgresql-client openssh build-base git make nodejs sqlite sqlite-dev imagemagick tzdata
RUN gem uninstall -aIx
RUN gem install bundler 
RUN bundle install --jobs 4
RUN RAILS_ENV=test bundle install --jobs 2
RUN gem install pry \
                pry-byebug \
                pry-doc \
                pry-git \
                pry-rails \
                pry-remote 

RUN mkdir -p /opt/panel_static
RUN mkdir -p /opt/app/public/static/
RUN ln -s /opt/panel_static/*  /opt/app/public/static/

EXPOSE 3000
CMD [ "rake", "db:migrate" ]
CMD [ "rails", "s", "-b", "0.0.0.0", "-p", "3000" ]
# CMD ["tail", "-f", "/dev/null"]

