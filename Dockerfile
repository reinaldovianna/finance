FROM allanbatista/finance-rails:5.0.0

MAINTAINER Allan Batista <eu@allanbatista.com.br>

ENV DEBIAN_FRONTEND=noninteractive

EXPOSE 3002
ADD . /opt/app
WORKDIR /opt/app

COPY ./docker/default /etc/nginx/sites-enabled/default
COPY ./docker/nginx.conf /etc/nginx/nginx.conf

RUN echo "" > /opt/app/config/application.yml
RUN bundle install
RUN RAILS_ENV=production SECRET_KEY_BASE=50724232e0e44b0142241fb1deb9556f312d85d0ca1ae14a46950aeb4d4dd7bfa69802d38395d722569e40eff4437ca2abacec9331438c3bdbfb771468f276fc rake assets:precompile

CMD export RAILS_ENV=production && bundle exec rake db:migrate && bundle exec rake db:seed && bundle exec puma -C ./config/puma.rb -d -v && /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf