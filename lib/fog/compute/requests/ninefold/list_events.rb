module Fog
  module Ninefold
    class Compute
      class Real

        def list_events(options = {})
          request('listEvents', options, :expects => [200],
                  :response_prefix => 'listeventsresponse/event', :response_type => Array)
        end

      end
    end
  end
end
