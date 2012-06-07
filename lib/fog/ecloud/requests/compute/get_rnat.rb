module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_rnat
      end

      class Mock
        def get_rnat(uri)
        end
      end
    end
  end
end
