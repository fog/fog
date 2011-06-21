require 'fog/core/collection'
require 'fog/compute/models/storm_on_demand/balancer'

module Fog
  module Compute
    class StormOnDemand

      class Balancers < Fog::Collection

        model Fog::Compute::StormOnDemand::Balancer

        def all
          data = connection.list_balancers.body['loadbalancers']
          load(data)
        end

      end

    end
  end
end
