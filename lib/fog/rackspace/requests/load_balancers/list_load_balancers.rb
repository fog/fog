module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def list_load_balancers(options = {})
          if options.key? :node_address
            query_string = "?nodeaddress=#{options[:node_address]}"
          else
            query_string = ''
          end

          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "loadbalancers.json?#{query_string}"
          )
        end
      end
    end
  end
end
