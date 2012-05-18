require 'fog/ecloudv2/models/compute/firewall_acl'

module Fog
  module Compute
    class Ecloudv2
      class FirewallAcls < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::FirewallAcl

        def all
          data = connection.get_firewall_acls(href).body
          data = data[:FirewallAcl] ? data[:FirewallAcl] : data
          load(data)
        end

        def get(uri)
          if data = connection.get_firewall_acl(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
