require 'fog/core/collection'
require 'fog/rackspace/models/load_balancer'

module Fog
  module Rackspace
    class LoadBalancer

      class LoadBalancers < Fog::Collection

        model Fog::Rackspace::LoadBalancer::LoadBalancer

        def all
          data = connection.list_load_balancers.body['loadBalancers']
          #TODO - Need to find a way to lazy load for performance.
          data = data.collect do |lb|
            connection.get_load_balancer(lb['id']).body['loadBalancer']
          end
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
