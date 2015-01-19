module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def delete_port(id)
          request(:method => 'DELETE', :path => "ports/#{id}", :expects => 204)
        end
      end
    end
  end
end
