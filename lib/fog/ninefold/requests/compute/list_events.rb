module Fog
  module Compute
    class Ninefold
      class Real

        def list_events(options = {})
          request('listEvents', options, :expects => [200],
                  :response_prefix => 'listeventsresponse/event', :response_type => Array)
        end

      end
    end
  end
end
