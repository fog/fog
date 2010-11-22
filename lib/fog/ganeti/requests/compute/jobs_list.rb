module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns a jobs status.

        def jobs_list
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/jobs"
          )
        end

      end

      class Mock

        def jobs_list
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
