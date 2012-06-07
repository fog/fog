module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_guest_processes
      end

      class Mock
        def get_guest_processes(uri)
        end
      end
    end
  end
end
