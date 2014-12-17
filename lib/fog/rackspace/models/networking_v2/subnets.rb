require 'fog/rackspace/models/networking_v2/subnet'

module Fog
  module Rackspace
    class NetworkingV2
      class Subnets < Fog::Collection
        model Fog::Rackspace::NetworkingV2::Subnet

        def all
          data = service.list_subnets.body['subnets']
          load(data)
        end

        def get(id)
          data = service.show_subnet(id).body['subnet']
          new(data)
        rescue Fog::Rackspace::NetworkingV2::NotFound
          nil
        end
      end
    end
  end
end
