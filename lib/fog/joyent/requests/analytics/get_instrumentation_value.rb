module Fog
  module Joyent
    class Analytics
      class Real
        def get_instrumentation_value(url, requested_start_time, ndatapoints, duration)
          request(
              :path => url,
              :method => 'GET',
              :debug_request => true,
              :expects => 200,
              :query => {
                  :ndatapoints => ndatapoints,
                  :start_time => requested_start_time.to_i,
                  :duration => duration
              }
          )
        end
      end
    end
  end
end
