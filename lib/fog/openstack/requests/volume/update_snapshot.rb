module Fog
  module Volume
    class OpenStack

      class Real
        def update_snapshot(snapshot_id, options = {})
          data = { 'snapshot' => {} }

          vanilla_options = [:display_name, :display_description, :metadata]
          vanilla_options.select{ |o| options.has_key?(o) }.each do |key|
            data['snapshot'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "snapshots/#{snapshot_id}"
          )
        end
      end

      class Mock
        def update_snapshot(snapshot_id, options = {})
          response = Excon::Response.new
          if snapshot = list_snapshots.body['snapshots'].detect { |_| _['id'] == snapshot_id }
            snapshot['display_name']        = options[:display_name] if options[:display_name]
            snapshot['display_description'] = options[:display_description] if options[:display_description]
            snapshot['metadata']            = options[:metadata] if options[:metadata]
            response.body = { 'snapshot' => snapshot }
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