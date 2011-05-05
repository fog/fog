module Fog
  module Ninefold
    class Compute
      class Real

        def list_events(options = {})
          request('listEvents', options, :expects => [200],
                  :response_prefix => 'listeventsresponse/event', :response_type => Array)
        end

      end

      class Mock

        def list_events(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
