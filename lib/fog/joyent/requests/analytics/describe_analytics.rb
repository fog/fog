module Fog
  module Joyent
    class Analytics
      class Real
        def describe_analytics(force = false)
          @describe_analytics = nil if force
          @describe_analytics ||= request(
              :path => "#{@joyent_username}/analytics",
              :method => "GET",
              :expects => 200,
              :idempotent => true
          )
        end
      end

      class Mock
        def describe_analytics(force = false)
          response = Excon::Response.new
          response.status = 200
          response.body = self.data[:describe_analytics]
          response
        end
      end
    end
  end
end
