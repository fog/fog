module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_networks
          request(:method => 'GET', :path => 'os-networksv2', :expects => 200)
        end
      end
    end
  end
end
