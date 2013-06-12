module Fog
  module Volume
    class OpenStack

      class Real
        def update_volume(volume_id, options = {})
          data = { 'volume' => {} }

          vanilla_options = [:display_name, :display_description, :metadata]
          vanilla_options.select{ |o| options.has_key?(o) }.each do |key|
            data['volume'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "volumes/#{volume_id}"
          )
        end
      end

      class Mock
        def update_volume(volume_id, options = {})
          response = Excon::Response.new
          if volume = list_volumes.body['volumes'].detect { |_| _['id'] == volume_id }
            volume['display_name']        = options[:display_name] if options[:display_name]
            volume['display_description'] = options[:display_description] if options[:display_description]
            volume['metadata']            = options[:metadata] if options[:metadata]
            response.body = { 'volume' => volume }
            response.status = 200
            response
          else
            raise Fog::Volume::OpenStack::NotFound
          end
        end
      end

    end
  end
end