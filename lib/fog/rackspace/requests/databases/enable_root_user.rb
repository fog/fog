module Fog
  module Rackspace
    class Databases
      class Real
        def enable_root_user(instance_id)
          request(
            :expects => 200,
            :method => 'POST',
            :path => "instances/#{instance_id}/root"
          )
        end
      end
    end
  end
end
