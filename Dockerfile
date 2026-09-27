FROM chatwoot/chatwoot:v4.18.0

USER root

RUN echo "gem 'omniauth_openid_connect'" >> /app/Gemfile \
    && cd /app \
    && bundle install

COPY authentik_oidc.rb /app/config/initializers/authentik_oidc.rb
COPY user_oidc.rb /app/config/initializers/user_oidc.rb
