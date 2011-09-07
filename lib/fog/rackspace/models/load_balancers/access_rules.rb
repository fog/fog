require 'fog/core/collection'
require 'fog/rackspace/models/load_balancers/access_rule'

module Fog
  module Rackspace
    class LoadBalancers
      class AccessRules < Fog::Collection
        model Fog::Rackspace::LoadBalancers::AccessRule

        attr_accessor :load_balancer

        def all
          load(all_raw)
        end

        def get(access_rule_id)
          data = all_raw.select { |access_rule| access_rule['id'] == access_rule_id }.first
          data && new(data)
        end

        private
        def all_raw
          requires :load_balancer
          data = connection.list_access_rules(load_balancer.id).body['accessList']
        end
      end
    end
  end
end
