require 'fog/core/collection'
require 'fog/hp/models/lb/load_balancer'

module Fog
  module HP
    class LB
      class LoadBalancers < Fog::Collection
        model Fog::HP::LB::LoadBalancer

        def all
          data = connection.list_load_balancers.body['load_balancers']
          load(data)
        end

        def get(record_id)
          record = connection.get_load_balancer_details(record_id).body['load_balancer']
          new(record)
        rescue Fog::HP::LB::NotFound
          nil
        end

      end
    end
  end
end