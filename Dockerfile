FROM rubylang/ruby:2.6.3-bionic
RUN apt-get update -qq && apt-get -y install postgresql-client libpq5 libpq-dev
RUN useradd ruby
WORKDIR /banana-rails

# gem install
COPY --chown=ruby:ruby Gemfile /banana-rails/Gemfile
COPY --chown=ruby:ruby Gemfile.lock /banana-rails/Gemfile.lock
RUN bundle install
RUN gem install pg -v '1.1.4' --source 'https://rubygems.org/'

COPY --chown=ruby:ruby . /banana-rails

# executable
COPY --chown=ruby:ruby entrypoint.sh /usr/bin/
RUN chown ruby:ruby /usr/bin/entrypoint.sh
USER ruby
ENTRYPOINT ["sh", "entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
