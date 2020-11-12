FROM ruby:2.7-slim-buster

RUN adduser --disabled-password --gecos '' app-runner &&\
  mkdir /home/app-runner/app &&\
  gem install bundler

WORKDIR /home/app-runner/app
USER app-runner
COPY --chown=app-runner:app-runner ./src/. .
# Bundler doesn't look in the app dir for its config in docker only the home dir of the user... gross :(
COPY --chown=app-runner:app-runner ./src/.bundle ../.bundle

RUN bundle install
EXPOSE 4567/tcp

ENTRYPOINT ["bundle", "exec", "app.rb"]
