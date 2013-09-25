require 'fog/core/collection'
require 'fog/storm_on_demand/models/network/balancer'

module Fog
  module Network
    class StormOnDemand

      class Balancers < Fog::Collection

        model Fog::Network::StormOnDemand::Balancer

        def all(options={})
          data = service.list_balancers(options).body['items']
          load(data)
        end

        def available(name)
          avail = service.check_balancer_available(:name => name).body
          avail['available'].to_i == 1 ? true : false
        end

        def create(options)
          balancer = service.create_balancer(options).body
          new(balancer)
        end

        def get(uniq_id)
          balancer = service.get_balancer_details(:uniq_id => uniq_id).body
          new(balancer)
        end

        def possible_nodes(options={})
          service.get_balancer_possible_nodes(options).body['items']
        end

        def strategies
          service.get_balancer_strategies.body['strategies']
        end

      end

    end
  end
end
