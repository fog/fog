module Fog
  module Rackspace
    class Databases
      class Real
        def list_flavors()
          request(
            :expects => 200,
            :method => 'GET',
            :path => 'flavors'
          )
        end
      end
    end
  end
end
