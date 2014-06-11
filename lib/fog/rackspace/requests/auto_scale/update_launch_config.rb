module Fog
  module Rackspace
    class AutoScale
      class Real
        def update_launch_config(group_id, options)
          body = options

          request(
            :expects => [204],
            :method => 'PUT',
            :path => "groups/#{group_id}/launch",
            :body => Fog::JSON.encode(body)
          )
        end
      end

      class Mock
        def update_launch_config(group_id, options)
          group = self.data[:autoscale_groups][group_id]
          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          config = group['launchConfiguration']

          config['args'] = options['args'] if options['args']
          config['type'] = options['type'] if options['type']

          request(:body => config)
        end
      end
    end
  end
end
