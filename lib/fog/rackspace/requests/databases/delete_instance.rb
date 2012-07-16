module Fog
  module Rackspace
    class Databases
      class Real
        def delete_instance(instance_id)
          request(
            :expects => 202,
            :method => 'DELETE',
            :path => "instances/#{instance_id}"
          )
        end
      end
    end
  end
end
