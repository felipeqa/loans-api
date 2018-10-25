FROM ruby:2.5.1

MAINTAINER Felipe Rodrigues <felipe_rodriguesx@hotmail.com>

ENV app_path /opt/project/
WORKDIR ${app_path}

COPY Gemfile* ${app_path}
COPY . ${app_path}

RUN bundle install \
    && rails db:create \
    && rails db:migrate \
    && rails db:seed


EXPOSE 3000:3000

ENTRYPOINT ["rails", "s"]
