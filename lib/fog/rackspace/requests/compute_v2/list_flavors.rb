module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_flavors
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'flavors'
          )
        end
      end

      class Mock
        def list_flavors
          flavors = self.data[:flavors].values.map { |f| Fog::Rackspace.keep(f, 'id', 'name', 'links') }
          response(:body => {"flavors" => flavors})
        end
      end
    end
  end
end
