module Fog
  module Rackspace
    class Databases
      class Real
        def create_database(instance_id, name, options = {})
          data = {
            'databases' => [{
              'name' => name,
              'character_set' => options[:character_set],
              'collate' => options[:collate]
            }]
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => 202,
            :method => 'POST',
            :path => "instances/#{instance_id}/databases"
          )
        end
      end
    end
  end
end
