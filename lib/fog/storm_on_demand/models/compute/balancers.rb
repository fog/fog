require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/balancer'

module Fog
  module Compute
    class StormOnDemand

      class Balancers < Fog::Collection

        model Fog::Compute::StormOnDemand::Balancer

        def all
          data = service.list_balancers.body['items']
          load(data)
        end

        def get(uniq_id)
          data = service.get_balancer(:uniq_id => uniq_id).body
          new(data)
        end

      end

    end
  end
end
