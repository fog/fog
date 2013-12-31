require 'fog/core/collection'
require 'fog/cloudstack/models/compute/network'

module Fog
  module Compute
    class Cloudstack

      class Networks < Fog::Collection

        model Fog::Compute::Cloudstack::Network

        def all
          data = service.list_networks["listnetworksresponse"]["network"] || []
          load(data)
        end

      end

    end
  end
end
