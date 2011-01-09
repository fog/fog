module Fog
  module TerremarkEcloud
    class Compute

      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_network_extensions'

        def get_network_extensions(network_extensions_uri)
          request({
                    :uri        => network_extensions_uri,
                    :idempotent => true,
                    :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetNetworkExtensions.new
                  })
        end

      end
    end
  end
end
