module Fog
  module Rackspace
    class BlockStorage
      class Real
        def create_snapshot(volume_id, options = {})
          data = {
            'snapshot' => {
              'volume_id' => volume_id
            }
          }

          data['snapshot']['display_name'] = options[:display_name] unless options[:display_name].nil?
          data['snapshot']['display_description'] = options[:display_description] unless options[:display_description].nil?
          data['snapshot']['force'] = options[:force] unless options[:force].nil?

          request(
            :body => Fog::JSON.encode(data),
            :expects => [200],
            :method => 'POST',
            :path => "snapshots"
          )
        end
      end
    end
  end
end
