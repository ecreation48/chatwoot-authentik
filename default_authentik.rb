# frozen_string_literal: true

class AuthentikDefaultLogin
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if redirect_to_authentik?(request)
      return [
        302,
        {
          'Location' => '/omniauth/authentik',
          'Content-Type' => 'text/html; charset=utf-8',
          'Cache-Control' => 'no-store'
        },
        ['Redirecting to Authentik...']
      ]
    end

    @app.call(env)
  end

  private

  def redirect_to_authentik?(request)
    return false unless ENV.fetch('AUTHENTIK_DEFAULT_LOGIN', 'true') == 'true'
    return false unless request.get?

    # On ne redirige que la page de login classique Chatwoot
    return false unless request.path == '/app/login'

    # Très important :
    # après un login OIDC réussi, Chatwoot revient sur /app/login
    # avec sso_auth_token + email.
    # Il ne faut surtout pas repartir vers Authentik à ce moment-là.
    return false if request.params['sso_auth_token'].present?
    return false if request.params['email'].present?
    return false if request.params['error'].present?

    true
  end
end

Rails.application.config.middleware.insert_before 0, AuthentikDefaultLogin
