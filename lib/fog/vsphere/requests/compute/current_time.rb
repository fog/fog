module Fog
  module Compute
    class Vsphere
      class Real

        def current_time
          @connection.serviceInstance.CurrentTime
        end

      end

      class Mock

        def current_time
          Time.now.utc
        end

      end
    end
  end
end
