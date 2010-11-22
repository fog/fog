module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Return a list of tags.

        def node_tags_list node_name
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/nodes/#{node_name}/tags"
          )
        end

      end

      class Mock

        def node_tag_list node_name
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
