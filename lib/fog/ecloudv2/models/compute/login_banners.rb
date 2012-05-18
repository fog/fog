require 'fog/ecloudv2/models/compute/login_banner'

module Fog
  module Compute
    class Ecloudv2
      class LoginBanners < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::LoginBanner

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
