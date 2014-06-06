require 'set'

module Fog
  module Compute
    class CloudSigma
      class Real
        def update_vlan(vlan_id, data)
          update_request("vlans/#{vlan_id}/", data)
        end
      end

      class Mock
        def update_vlan(vlan_id, data)
          mock_update(data, :vlans, 200, vlan_id)
        end
      end
    end
  end
end
