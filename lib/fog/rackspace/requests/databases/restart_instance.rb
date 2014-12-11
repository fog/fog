module Fog
  module Rackspace
    class Databases
      class Real
        def restart_instance(instance_id)
          data = {
            'restart' => {}
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => 202,
            :method => 'POST',
            :path => "instances/#{instance_id}/action"
          )
        end
      end
    end
  end
end
