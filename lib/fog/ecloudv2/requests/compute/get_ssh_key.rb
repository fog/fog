module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_ssh_key
      end

      class Mock
        def get_ssh_key(uri)
        end
      end
    end
  end
end
