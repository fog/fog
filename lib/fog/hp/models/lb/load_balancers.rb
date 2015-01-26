require 'fog/core/collection'
require 'fog/hp/models/lb/load_balancer'

module Fog
  module HP
    class LB
      class LoadBalancers < Fog::Collection
        model Fog::HP::LB::LoadBalancer

        def all
          data = service.list_load_balancers.body['loadBalancers']
          load(data)
        end

        def get(lb_id)
          ### Inconsistent API - does not return a 'loadBalancer'
          lb = service.get_load_balancer(lb_id).body
          new(lb)
        rescue Fog::HP::LB::NotFound
          nil
        end
      end
    end
  end
end
