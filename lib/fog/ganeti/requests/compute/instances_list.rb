module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns a list of all available instances.
        #
        # If the optional bulk parameter (?bulk=1) is provided,
        # the output contains detailed information about instances as a list.

        def instances_list opts = {}
          request(
            :expects => 200,
            :method  => 'GET',
            :query   => opts.delete(:query),
            :path    => "/2/instances"
          )
        end

      end

      class Mock

        def instances_list
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
