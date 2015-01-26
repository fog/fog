module Fog
  module Rackspace
    class AutoScale
      class Real
        def get_launch_config(group_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/launch"
          )
        end
      end

      class Mock
        def get_launch_config(group_id)
          group = self.data[:autoscale_groups][group_id]

          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          response(:body => {"launchConfiguration" => group['launchConfiguration']})
        end
      end
    end
  end
end
