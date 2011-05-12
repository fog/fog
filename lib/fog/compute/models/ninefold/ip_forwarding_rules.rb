require 'fog/core/collection'
require 'fog/compute/models/ninefold/ip_forwarding_rule'

module Fog
  module Ninefold
    class Compute

      class IpForwardingRules < Fog::Collection

        model Fog::Ninefold::Compute::IpForwardingRule

        def all
          data = connection.list_ip_forwarding_rules
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = connection.list_ip_forwarding_rules(:id => identifier)
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
