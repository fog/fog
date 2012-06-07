module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_guest_process
      end

      class Mock
        def get_guest_process(uri)
        end
      end
    end
  end
end
