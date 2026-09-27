# frozen_string_literal: true

Rails.application.config.to_prepare do
  unless User.omniauth_providers.include?(:authentik)
    User.omniauth_providers << :authentik
  end
end
