require 'fog/core/collection'
require 'fog/hp/models/network/security_group_rule'

module Fog
  module HP
    class Network

      class SecurityGroupRules < Fog::Collection

        attribute :filters

        model Fog::HP::Network::SecurityGroupRule

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          load(service.list_security_group_rules(filters).body['security_group_rules'])
        end

        def get(sec_group_rule_id)
          if sec_group_rule = service.get_security_group_rule(sec_group_rule_id).body['security_group_rule']
            new(sec_group_rule)
          end
        rescue Fog::HP::Network::NotFound
          nil
        end

      end
    end
  end
end
