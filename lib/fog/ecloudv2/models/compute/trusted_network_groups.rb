require 'fog/ecloudv2/models/compute/trusted_network_group'

module Fog
  module Compute
    class Ecloudv2
      class TrustedNetworkGroups < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::TrustedNetworkGroup

        def all
          data = connection.get_trusted_network_groups(href).body
          data = data[:TrustedNetworkGroup] ? data[:TrustedNetworkGroup] : data
          load(data)
        end

        def get(uri)
          if data = connection.get_trusted_network_group(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
