module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_load_balancer_usage(load_balancer_id, options = {})
          #TODO - Didn't implement usage/current.  Not sure if it is needed
          if options.has_key? :start_time and options.has_key? :end_time
            query = "?startTime=#{options[:start_time]}&endTime=#{options[:end_time]}"
          else
            query = ''
          end
          request(
            :expects => 200,
            :path => "loadbalancers/#{load_balancer_id}/usage#{query}",
            :method => 'GET'
          )
         end
      end
    end
  end
end
