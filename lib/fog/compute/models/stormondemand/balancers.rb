require 'fog/core/collection'
require 'fog/compute/models/stormondemand/balancer'

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
