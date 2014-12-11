module Fog
  module Rackspace
    class Orchestration
      class Real
        def build_info
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => 'build_info'
          )
        end
      end
    end
  end
end
