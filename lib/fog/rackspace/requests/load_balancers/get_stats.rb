module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_stats(load_balancer_id)
          request(
              :expects => 200,
              :path => "loadbalancers/#{load_balancer_id}/stats",
              :method => 'GET'
          )
        end
      end

      class Mock
        def get_stats(load_balancer_id)
          mock_data = {
              'connectTimeOut' => 0,
              'connectError' => 1,
              'connectFailure' => 2,
              'dataTimedOut' => 3,
              'keepAliveTimedOut' => 4,
              'maxConn' => 5
          }

          Excon::Response.new(:body => mock_data, :status => 200)
        end
      end
    end
  end
end
