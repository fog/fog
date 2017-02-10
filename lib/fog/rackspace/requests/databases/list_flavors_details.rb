module Fog
  module Rackspace
    class Databases
      class Real
        def list_flavors_details()
          request(
            :expects => 200,
            :method => 'GET',
            :path => 'flavors/detail'
          )
        end
      end
    end
  end
end
