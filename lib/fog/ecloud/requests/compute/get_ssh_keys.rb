module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_ssh_keys
      end

      class Mock
        def get_ssh_keys(uri)
        end
      end
    end
  end
end
