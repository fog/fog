module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_networks
          request(:method => 'GET', :path => 'os-networksv2', :expects => 200)
        end
      end

      class Mock
        def list_networks
          networks = self.data[:networks].values
          response(:body => { 'networks' => networks })
        end
      end
    end
  end
end
