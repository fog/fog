require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/balancer'

module Fog
  module Compute
    class StormOnDemand

      class Balancers < Fog::Collection

        model Fog::Compute::StormOnDemand::Balancer

        def all
          data = connection.list_balancers.body['items']
          load(data)
        end

      end

    end
  end
end
