require 'fog/ecloud/models/compute/login_banner'

module Fog
  module Compute
    class Ecloud
      class LoginBanners < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::LoginBanner

        def all
          data = connection.get_login_banners(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_login_banner(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
