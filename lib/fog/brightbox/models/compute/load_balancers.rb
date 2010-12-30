require 'fog/core/collection'
require 'fog/brightbox/models/compute/load_balancer'

module Fog
  module Brightbox
    class Compute

      class LoadBalancers < Fog::Collection

        model Fog::Brightbox::Compute::LoadBalancer

        def all
          data = connection.list_load_balancers
          load(data)
        end

        def get(identifier)
          data = connection.get_load_balancer(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
