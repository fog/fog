module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns information about an instance, similar to
        # the bulk output from +#instances_list+.

        def instance_list instance_name
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/instances/#{instance_name}"
          )
        end

      end

      class Mock

        def instance_list instance_name
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
