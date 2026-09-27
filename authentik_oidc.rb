# frozen_string_literal: true

return unless ENV['AUTHENTIK_CLIENT_ID'].present?

# Permet d'ouvrir directement /omniauth/authentik depuis le navigateur.
# OmniAuth 2 privilégie normalement POST.
OmniAuth.config.allowed_request_methods = %i[get post]
OmniAuth.config.silence_get_warning = true

Devise.setup do |config|
  config.omniauth :openid_connect,
                  {
                    name: :authentik,

                    scope: %i[
                      openid
                      profile
                      email
                    ],

                    response_type: :code,

                    issuer: ENV.fetch('AUTHENTIK_ISSUER'),

                    discovery: true,

                    client_options: {
                      identifier: ENV.fetch('AUTHENTIK_CLIENT_ID'),
                      secret: ENV.fetch('AUTHENTIK_CLIENT_SECRET'),

                      redirect_uri: File.join(
                        ENV.fetch('FRONTEND_URL'),
                        'omniauth/authentik/callback'
                      )
                    }
                  }
end
