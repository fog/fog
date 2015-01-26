module Fog
  module Compute
    class CloudSigma
      class Real
        def list_fwpolicies
          list_request('fwpolicies/detail/')
        end
      end

      class Mock
        def list_fwpolicies
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
