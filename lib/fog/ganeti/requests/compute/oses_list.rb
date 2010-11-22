module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Return a list of all OSes.

        def oses_list
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/os"
          )
        end

      end

      class Mock

        def oses_list
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
