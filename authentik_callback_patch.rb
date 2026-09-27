# frozen_string_literal: true

module AuthentikCompactOmniauthCallback
  def redirect_callbacks
    auth = request.env['omniauth.auth']

    # Pour les autres providers, on conserve le comportement normal.
    return super unless params[:provider] == 'authentik' && auth.present?

    # Chatwoot n'a besoin que de l'identité de l'utilisateur.
    # Les credentials OIDC (access_token, id_token...) peuvent dépasser
    # la limite de 4 Ko du cookie de session.
    compact_auth = auth.except('extra', 'credentials')

    session['dta.omniauth.auth'] = compact_auth
    session['dta.omniauth.params'] = request.env['omniauth.params']

    devise_mapping = get_devise_mapping
    redirect_route = get_redirect_route(devise_mapping)

    redirect_to redirect_route, { status: 307 }.merge(redirect_options)
  end
end

Rails.application.config.to_prepare do
  controller = DeviseOverrides::OmniauthCallbacksController

  unless controller.ancestors.include?(AuthentikCompactOmniauthCallback)
    controller.prepend(AuthentikCompactOmniauthCallback)
  end
end
