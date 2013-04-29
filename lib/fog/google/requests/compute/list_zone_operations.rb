module Fog
  module Compute
    class Google

      class Mock

        def list_zone_operations
          Fog::Mock.not_implemented
        end

      end

      class Real

        def list_zone_operations
        end
      end
    end
  end
end
