require 'fog/joyent/models/compute/network'
module Fog
  module Compute
    class Joyent
      class Networks < Fog::Collection
        model Fog::Compute::Joyent::Network

        def all
          load(service.list_networks.body)
        end
      end
    end
  end
end
