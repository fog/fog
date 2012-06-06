module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_template
      end

      class Mock
        def get_template(uri)
        end
      end
    end
  end
end
