require 'fog/ecloud/models/compute/trusted_network_group'

module Fog
  module Compute
    class Ecloud
      class TrustedNetworkGroups < Fog::Ecloud::Collection
        identity :href

        model Fog::Compute::Ecloud::TrustedNetworkGroup

        def all
          data = service.get_trusted_network_groups(href).body
          data = data[:TrustedNetworkGroup] ? data[:TrustedNetworkGroup] : data
          load(data)
        end

        def get(uri)
          if data = service.get_trusted_network_group(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
