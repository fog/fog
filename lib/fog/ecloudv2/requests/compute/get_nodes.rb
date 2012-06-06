module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_nodes
      end

      class Mock
        def get_nodes(uri)
        end
      end
    end
  end
end
