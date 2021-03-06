FROM ruby:2.5.1-alpine3.7

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN apk --no-cache add alpine-sdk postgresql-dev postgresql-libs postgresql-client less && bundle install && apk del alpine-sdk

EXPOSE 9292