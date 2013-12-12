module Fog
  module Joyent
    class Analytics
      class Real
        def describe_analytics
          @describe_analytics ||= request(
              :path => "#{@joyent_username}/analytics",
              :method => "GET",
              :expects => 200
          )
        end
      end
    end
  end
end
