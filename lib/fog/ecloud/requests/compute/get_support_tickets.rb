module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_support_tickets
      end

      class Mock
        def get_support_tickets(uri)
        end
      end
    end
  end
end
