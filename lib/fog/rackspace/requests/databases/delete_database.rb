module Fog
  module Rackspace
    class Databases
      class Real
        def delete_database(instance_id, name)
          request(
            :expects => 202,
            :method => 'DELETE',
            :path => "instances/#{instance_id}/databases/#{name}"
          )
        end
      end
    end
  end
end
