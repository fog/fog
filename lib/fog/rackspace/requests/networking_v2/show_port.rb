module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def show_port(id)
          request(:method => 'GET', :path => "ports/#{id}", :expects => 200)
        end
      end
    end
  end
end
