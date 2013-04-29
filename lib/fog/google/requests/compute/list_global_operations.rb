module Fog
  module Compute
    class Google

      class Mock

        def list_global_operations
          Fog::Mock.not_implemented
        end

      end

      class Real

        def list_global_operations
        end
      end
    end
  end
end
