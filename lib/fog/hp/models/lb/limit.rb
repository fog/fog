require 'fog/core/model'

module Fog
  module HP
    class LB
      class Limit < Fog::Model

        identity :id
        attribute :max_load_balancer_name_length, :aliases => 'maxLoadBalancerNameLength'
        attribute :max_load_balancers, :aliases => 'maxLoadBalancers'
        attribute :max_nodes_per_load_balancer, :aliases => 'maxNodesPerLoadBalancer'
        attribute :max_vips_per_load_balancer, :aliases => 'maxVIPsPerLoadBalancer'

      end
    end
  end
end