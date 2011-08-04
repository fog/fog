module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_usage(options = {})
          if options.has_key? :start_time and options.has_key? :end_time
            query = "?startTime=#{options[:start_time]}&endTime=#{options[:end_time]}"
          else
            query = ''
          end
          request(
            :expects => 200,
            :path => "loadbalancers/usage#{query}",
            :method => 'GET'
          )
         end
      end
    end
  end
end
