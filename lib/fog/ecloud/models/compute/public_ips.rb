require 'fog/ecloud/models/compute/public_ip'

module Fog
  module Compute
    class Ecloud
      class PublicIps < Fog::Ecloud::Collection
        identity :href

        model Fog::Compute::Ecloud::PublicIp

        def all
          data = service.get_public_ips(href).body
          data = data[:PublicIp] ? data[:PublicIp] : data
          load(data)
        end

        def get(uri)
          data = service.get_public_ip(uri).body
          new(data)
        rescue Fog::Errors::NotFound
          nil
        end

        def activate
          data = service.public_ip_activate(href + "/action/activatePublicIp").body
          ip = Fog::Compute::Ecloud::PublicIps.new(:service => service, :href => data[:href])[0]
        end
      end
    end
  end
end
