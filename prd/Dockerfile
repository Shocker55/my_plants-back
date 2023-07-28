FROM ruby:3.2.2
ENV TZ Asia/Tokyo
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       nodejs
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler
RUN bundle install --without test development
ADD . /app

COPY /prd/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# entrypoint.shでexec "$@"としているためCMDで渡されるオプションが実行されることになる
CMD ["unicorn", "-p", "3000", "-c", "config/unicorn.rb", "-E", "production"]