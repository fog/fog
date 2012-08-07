module Fog
  module Compute
    class RackspaceV2
      class Real
        def create_server(name, image_id, flavor_id, min_count, max_count, options = {})
          data = {
            'server' => {
              'name' => name,
              'imageRef' => image_id,
              'flavorRef' => flavor_id,
              'minCount' => min_count,
              'maxCount' => max_count
            }
          }

          data['server']['diskConfig'] = options[:disk_config] unless options[:disk_config].nil?

          request(
            :body => Fog::JSON.encode(data),
            :expects => [202],
            :method => 'POST',
            :path => "servers"
          )
        end
      end
    end
  end
end
