module Fog
  module Ninefold
    class Compute
      class Real

        def list_zones(options = {})
          request('listZones', options, :expects => [200],
                  :response_prefix => 'listzonesresponse/zone', :response_type => Array)
        end

      end

      class Mock

        def list_zones(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
