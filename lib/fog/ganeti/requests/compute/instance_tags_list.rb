module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Return a list of tags.

        def instance_tags_list instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/instances/#{instance_name}/tags"
          )
        end

      end

      class Mock

        def instance_tags_list instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
