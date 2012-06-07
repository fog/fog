require 'fog/ecloud/models/compute/public_ip'

module Fog
  module Compute
    class Ecloud
      class PublicIps < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::PublicIp

        def all
          data = connection.get_public_ips(href).body
          data = data[:PublicIp] ? data[:PublicIp] : data
          load(data)
        end

        def get(uri)
          if data = connection.get_public_ip(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def activate
          data = connection.public_ip_activate(href + "/action/activatePublicIp").body
          ip = Fog::Compute::Ecloud::PublicIps.new(:connection => connection, :href => data[:href])[0]
        end
      end
    end
  end
end
