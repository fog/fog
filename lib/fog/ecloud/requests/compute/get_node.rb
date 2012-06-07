module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_node
      end

      class Mock
        def get_node(uri)
        end
      end
    end
  end
end
