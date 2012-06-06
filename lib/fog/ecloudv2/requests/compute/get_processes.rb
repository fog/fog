module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_processes
      end

      class Mock
        def get_processes(uri)
        end
      end
    end
  end
end
