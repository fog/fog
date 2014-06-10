module Fog
  module Rackspace
    class AutoScale
      class Real
        def delete_group(group_id)
          request(
          :expects => [204],
          :method => 'DELETE',
          :path => "groups/#{group_id}"
          )
        end
      end

      class Mock
        def delete_group(group_id)
           self.data[:autoscale_groups].delete(group_id)
           response(:status => 204)
        end
      end
    end
  end
end
