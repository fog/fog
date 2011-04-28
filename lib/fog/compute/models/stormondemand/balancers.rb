require 'fog/core/collection'
require 'fog/compute/models/stormondemand/balancer'

module Fog
  module Stormondemand
    class Compute

      class Balancers < Fog::Collection

        model Fog::Stormondemand::Compute::Balancer

        def all
          data = connection.list_balancers.body['loadbalancers']
          load(data)
        end

      end

    end
  end
end
