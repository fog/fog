require 'fog/core/collection'
require 'fog/linode/models/compute/node_balancer_flavor'

module Fog
  module Compute
    class Linode
      class NodeBalancerFlavors < Fog::Collection
        model Fog::Compute::Linode::NodeBalancerFlavor

        def all
          load node_balancer_flavors
        end

        private
        def node_balancer_flavors
          service.avail_nodebalancers.body['DATA'].map { |node_balancer_flavor| map_node_balancer_flavor node_balancer_flavor }
        end

        def map_node_balancer_flavor(node_balancer_flavor)
          node_balancer_flavor = node_balancer_flavor.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          node_balancer_flavor.merge! :price_monthly => node_balancer_flavor[:monthly],
                                      :price_hourly => node_balancer_flavor[:hourly]
        end
      end
    end
  end
end
