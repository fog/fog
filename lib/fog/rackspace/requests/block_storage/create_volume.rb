module Fog
  module Rackspace
    class BlockStorage
      class Real
        def create_volume(size, options = {})
          data = {
            'volume' => {
              'size' => size
            }
          }

          data['volume']['display_name'] = options[:display_name] unless options[:display_name].nil?
          data['volume']['display_description'] = options[:display_description] unless options[:display_description].nil?
          data['volume']['volume_type'] = options[:volume_type] unless options[:volume_type].nil?
          data['volume']['availability_zone'] = options[:availability_zone] unless options[:availability_zone].nil?

          request(
            :body => Fog::JSON.encode(data),
            :expects => [200],
            :method => 'POST',
            :path => "volumes"
          )
        end
      end
    end
  end
end
