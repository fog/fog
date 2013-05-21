require 'fog/core/collection'
require 'fog/hp/models/lb/limit'

module Fog
  module HP
    class LB
      class Limits < Fog::Collection
        model Fog::HP::LB::Limit

        #{
        #    "limits" : {
        #    "absolute" : {
        #    "values" : {
        #    "maxLoadBalancerNameLength" : 128,
        #    "maxLoadBalancers" : 20,
        #    "maxNodesPerLoadBalancer" : 5,
        #    "maxVIPsPerLoadBalancer" : 1
        #}
        #}
        #}
        #}
        def all
          data = service.list_limits.body['limits']['absolute']['values']
          load([data])
        end
      end
    end
  end
end
