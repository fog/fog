module Fog
  module Rackspace
    class AutoScale
      class Real
        def update_group_config(group_id, options)
          body = options

          request(
            :expects => [204],
            :method => 'PUT',
            :path => "groups/#{group_id}/config",
            :body => Fog::JSON.encode(body)
          )
        end
      end

      class Mock
        def update_group_config(group_id, options)
          group = self.data[:autoscale_groups][group_id]
          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          config = group['groupConfiguration']

          config['name'] = options['name'] if options['name']
          config['cooldown'] = options['cooldown'] if options['cooldown']
          config['minEntities'] = options['minEntities'] if options['minEntities']
          config['maxEntities'] = options['maxEntities'] if options['maxEntities']
          config['metadata'] = options['metadata'] if options['metadata']

          request(:body => config)
        end
      end
    end
  end
end
