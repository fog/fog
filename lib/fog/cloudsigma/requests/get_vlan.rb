module Fog
  module Compute
    class CloudSigma
      class Real
        def get_vlan(vlan)
          get_request("vlans/#{vlan}/")
        end
      end

      class Mock
        def get_vlan(vlan)
          mock_get(:vlans, 200, vlan)
        end
      end
    end
  end
end
