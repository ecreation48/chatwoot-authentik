# frozen_string_literal: true

return unless ENV['AUTHENTIK_CLIENT_ID'].present?

Devise.setup do |config|
  config.omniauth :openid_connect,
                  {
                    name: :authentik,
                    scope: %i[openid profile email],
                    response_type: :code,
                    issuer: ENV.fetch('AUTHENTIK_ISSUER'),
                    discovery: true,
                    client_options: {
                      identifier: ENV.fetch('AUTHENTIK_CLIENT_ID'),
                      secret: ENV.fetch('AUTHENTIK_CLIENT_SECRET'),
                      redirect_uri: "#{ENV.fetch('FRONTEND_URL')}/auth/authentik/callback"
                    }
                  }
end
