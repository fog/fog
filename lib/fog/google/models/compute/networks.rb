require 'fog/core/collection'

#TODO: remove it after integration with fog
require "fog/google/models/compute/network"

module Fog
  module Compute
    class Google 
      class Networks < Fog::Collection

        model Fog::Compute::Google::Network

        def all(filter = {})
          data = service.list_networks.body["items"] || []
          load(data)
        end

      end
    end
  end
end
