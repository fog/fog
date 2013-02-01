module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_network(id)
          request(:method => 'GET', :path => "os-networksv2/#{id}", :expects => 200)
        end
      end
    end
  end
end
