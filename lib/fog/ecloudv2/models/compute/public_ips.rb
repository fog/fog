require 'fog/ecloudv2/models/compute/public_ip'

module Fog
  module Compute
    class Ecloudv2
      class PublicIps < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::PublicIp

        def all
          data = connection.get_public_ips(href).body[:PublicIp]
          load(data)
        end

        def get(uri)
          if data = connection.get_public_ip(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
