module Fog
  module Rackspace
    class Databases
      class Real
        def check_root_user(instance_id)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "instances/#{instance_id}/root"
          )
        end
      end
    end
  end
end
