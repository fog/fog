require 'fog/ecloud/models/compute/firewall_acl'

module Fog
  module Compute
    class Ecloud
      class FirewallAcls < Fog::Ecloud::Collection

        model Fog::Compute::Ecloud::FirewallAcl

        attribute :href, :aliases => :Href

        def all
          check_href! :message => "the Firewall ACL href for the network you want to enumerate"
          if data = connection.get_firewall_acls(href).body[:FirewallAcl]
            data = [ data ] if data.is_a?(Hash)
            load(data)
          end
        end

        def get(uri)
          if data = connection.get_firewall_acl(uri).body
            new(data)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
