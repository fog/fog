module Fog
  module Rackspace
    class Databases
      class Real
        def list_instances()
          request(
            :expects => 200,
            :method => 'GET',
            :path => 'instances'
          )
        end
      end
    end
  end
end
