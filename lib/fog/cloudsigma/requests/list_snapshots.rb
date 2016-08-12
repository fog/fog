module Fog
  module Compute
    class CloudSigma
      class Real
        def list_snapshots
          list_request('snapshots/detail/')
        end
      end

      class Mock
        def list_snapshots
          mock_list(:snapshots, 200)
        end
      end
    end
  end
end
