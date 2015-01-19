require 'fog/core/collection'
require 'fog/cloudstack/models/compute/port_forwarding_rule'

module Fog
  module Compute
    class Cloudstack
      class PortForwardingRules < Fog::Collection
        model Fog::Compute::Cloudstack::PortForwardingRule

        def all(options = {})
          response = service.list_port_forwarding_rules(options)
          port_forwarding_rules = response["listportforwardingrulesresponse"]["portforwardingrule"] || []
          load(port_forwarding_rules)
        end

        def get(address_id)
          options = { 'id' => address_id }
          response = service.list_port_forwarding_rules(options)
          port_forwarding_rules = response["listportforwardingrulesresponse"]["portforwardingrule"].first
          new(port_forwarding_rules)
        end
      end
    end
  end
end
