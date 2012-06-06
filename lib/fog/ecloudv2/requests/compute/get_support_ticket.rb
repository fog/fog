module Fog
  module Compute
    class Ecloudv2

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
