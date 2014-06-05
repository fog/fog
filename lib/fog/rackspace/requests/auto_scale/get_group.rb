module Fog
  module Rackspace
    class AutoScale
      class Real
        def get_group(group_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}"
          )
        end
      end

      class Mock
        def get_group(group_id)
          group = self.data[:autoscale_groups][group_id]
          if server.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          else
            response(:body => {"group" => group})
          end
        end
      end
    end
  end
end
