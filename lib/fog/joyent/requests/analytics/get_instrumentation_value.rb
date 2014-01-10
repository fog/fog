module Fog
  module Joyent
    class Analytics
      class Real
        def get_instrumentation_value(url, requested_start_time, ndatapoints, duration)
          request(
              :path => url,
              :method => 'GET',
              :expects => 200,
              :idempotent => true,
              :query => {
                  :ndatapoints => ndatapoints,
                  :start_time => requested_start_time.to_i,
                  :duration => duration
              }
          )
        end
      end

      class Mock
        def get_instrumentation_value(url, requested_start_time, ndatapoints, duration)
          response = Excon::Response.new
          response.status = 200
          response.body = [self.data[:values]]
          response
        end
      end
    end
  end
end
