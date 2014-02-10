module Fog
  module Rackspace
    class Databases
      class Real
        def get_instance(instance_id)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "instances/#{instance_id}"
          )
        end
      end
    end
  end
end
