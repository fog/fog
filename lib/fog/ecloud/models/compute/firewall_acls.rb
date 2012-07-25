require 'fog/ecloud/models/compute/firewall_acl'

module Fog
  module Compute
    class Ecloud
      class FirewallAcls < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::FirewallAcl

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
