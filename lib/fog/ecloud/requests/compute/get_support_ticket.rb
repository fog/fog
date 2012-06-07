module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_support_ticket
      end

      class Mock
        def get_support_ticket(uri)
        end
      end
    end
  end
end
