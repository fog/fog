module Fog
  module Rackspace
    class Databases
      class Real
        def list_databases(instance_id)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "instances/#{instance_id}/databases"
          )
        end
      end
    end
  end
end
