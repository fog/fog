module Fog
  module Compute
    class RackspaceV2
      class Real
        def delete_network(id)
          request(:method => 'DELETE', :path => "os-networksv2/#{id}", :expects => 202)
        end
      end
    end
  end
end
