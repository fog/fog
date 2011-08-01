require 'fog/core/collection'
require 'fog/rackspace/models/load_balancer'

module Fog
  module Rackspace
    class LoadBalancer

      class LoadBalancers < Fog::Collection

        model Fog::Rackspace::LoadBalancer::LoadBalancer

        def all
          data = connection.list_load_balancers.body['loadBalancers']
          load(data)
        end

        def get(load_balancer_id)
          if load_balancer = connection.get_load_balancer(load_balancer_id).body['loadBalancer']
            new(load_balancer)
          end
        rescue Fog::Rackspace::LoadBalancer::NotFound
          nil
        end
      end
    end
  end
end
