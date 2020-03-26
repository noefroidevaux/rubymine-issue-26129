FROM ruby:2.6.5

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  vim \
  nodejs \
  yarn

ENV EDITOR vim

WORKDIR /app

ENV PATH ./bin:$PATH

COPY Gemfile* ./
RUN gem update --system
RUN gem install bundler -v 2.1.4
RUN bundle check || bundle install

COPY package.json yarn.lock ./
RUN yarn install --check-files

COPY . ./

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
