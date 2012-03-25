require 'fog/core/collection'
require 'fog/ibm/models/compute/vlan'

module Fog
  module Compute
    class IBM

      class Vlans < Fog::Collection

        model Fog::Compute::IBM::Vlan

        def all
          load(connection.list_vlans.body['vlan'])
        end

        def get(vlan_id)
          begin
            vlan = connection.list_vlans.body
            new(vlan['vlan'].find{|vlan| vlan['id'] == vlan_id.to_s })
          rescue Fog::Compute::IBM::NotFound
            nil
          end
        end

      end
    end
  end
end
