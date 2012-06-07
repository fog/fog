module Fog
  module Compute
    class Ecloud

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
