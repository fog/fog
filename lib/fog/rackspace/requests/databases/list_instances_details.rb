module Fog
  module Rackspace
    class Databases
      class Real
        def list_instances_details()
          request(
            :expects => 200,
            :method => 'GET',
            :path => 'instances/detail'
          )
        end
      end
    end
  end
end
