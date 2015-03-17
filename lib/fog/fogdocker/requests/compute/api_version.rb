module Fog
  module Compute
    class Fogdocker
      class Real
        def api_version
          Docker.version(@connection)
        end
      end
      class Mock
        def api_version
          {'Version' => '1.6'}
        end
      end
    end
  end
end
