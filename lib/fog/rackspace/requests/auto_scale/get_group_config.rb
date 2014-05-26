module Fog
  module Rackspace
    class AutoScale
      class Real
        def get_group_config(group_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/config"
          )
        end
      end

      class Mock
        def get_group_config(group_id)
          group = self.data[:autoscale_groups][group_id]

          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          response(:body => {"groupConfiguration" => group['groupConfiguration']})
        end
      end
    end
  end
end
