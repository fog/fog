require 'fog/core/collection'
require 'fog/ninefold/models/compute/ip_forwarding_rule'

module Fog
  module Compute
    class Ninefold
      class IpForwardingRules < Fog::Collection
        model Fog::Compute::Ninefold::IpForwardingRule

        def all
          data = service.list_ip_forwarding_rules
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.list_ip_forwarding_rules(:id => identifier)
          if data.empty?
            nil
          else
            new(data[0])
          end
        end
      end
    end
  end
end
