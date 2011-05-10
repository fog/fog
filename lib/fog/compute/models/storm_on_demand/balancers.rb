require 'fog/core/collection'
require 'fog/compute/models/storm_on_demand/balancer'

module Fog
  module StormOnDemand
    class Compute

      class Balancers < Fog::Collection

        model Fog::StormOnDemand::Compute::Balancer

        def all
          data = connection.list_balancers.body['loadbalancers']
          load(data)
        end

      end

    end
  end
end
