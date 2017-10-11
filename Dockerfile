FROM ruby:2.4.1

RUN apt-get update -qq
RUN apt-get install -qq -y --no-install-recommends
RUN apt-get install -y build-essential libpq-dev postgresql-client

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

LABEL maintainer="Chen Huang"

CMD puma -C config/puma.rb
