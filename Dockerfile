FROM chatwoot/chatwoot:v4.18.0

USER root

WORKDIR /app

# Ajout du provider OpenID Connect
RUN printf "\ngem 'omniauth_openid_connect'\n" >> Gemfile \
    && bundle install

# Ajout d'Authentik aux providers OmniAuth autorisés par Chatwoot
RUN ruby -e 'p="app/models/user.rb"; s=File.read(p); old="omniauth_providers: [:google_oauth2, :saml]"; new="omniauth_providers: [:google_oauth2, :saml, :authentik]"; raise "Impossible de trouver omniauth_providers dans User" unless s.include?(old); File.write(p, s.sub(old,new))'

COPY authentik_oidc.rb /app/config/initializers/authentik_oidc.rb
COPY default_authentik.rb /app/config/initializers/default_authentik.rb
