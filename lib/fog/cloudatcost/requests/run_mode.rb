module Fog
  module Compute
    class CloudAtCost
      class Real
        def run_mode(id, action)
          body = { :sid => "#{id}", :mode => "#{action}" }
          request(
            :expects => [200],
            :method  => 'POST',
            :path    => 'api/v1/runmode.php',
            :body    => body,
          )
        end
      end

      class Mock
        def run_mode(id, action)
          response         = Excon::Response.new
          response.status  = 200
          response.body    = {
            'server_id'   => Fog::Mock.random_numbers(1).to_i,
            'api'        => 'v1',
            'status'     => 'ok',
            'result'     => 'successful',
            'time'       => 12312323,
          }
          response
        end
      end
    end
  end
end
