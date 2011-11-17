require 'fog/core/collection'
require 'fog/brightbox/models/compute/firewall_rule'

module Fog
  module Compute
    class Brightbox

      class FirewallRules < Fog::Collection

        model Fog::Compute::Brightbox::FirewallRule

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = connection.get_firewall_rule(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end