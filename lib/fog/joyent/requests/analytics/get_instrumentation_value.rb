module Fog
  module Joyent
    class Analytics
      class Real
        def get_instrumentation_value(url, requested_start_time, requested_end_time)
          request(
              :path => url,
              :method => 'GET',
              :debug_request => true,
              :expects => 200,
              :query => {
                  :start_time => requested_start_time.to_i,
                  :duration => requested_end_time.to_i - requested_start_time.to_i,
                  :end_time => requested_end_time.to_i
              }
          )
        end
      end
    end
  end
end
