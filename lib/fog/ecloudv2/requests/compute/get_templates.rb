module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_templates
      end

      class Mock
        def get_templates(uri)
        end
      end
    end
  end
end
