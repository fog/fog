require 'fog/core/collection'
require 'fog/brightbox/models/compute/firewall_policy'

module Fog
  module Compute
    class Brightbox

      class FirewallPolicies < Fog::Collection

        model Fog::Compute::Brightbox::FirewallPolicy

        def all
          data = service.list_firewall_policies
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_firewall_policy(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
