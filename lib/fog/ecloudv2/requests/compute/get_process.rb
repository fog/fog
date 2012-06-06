module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_process
      end

      class Mock
        def get_process(uri)
        end
      end
    end
  end
end
