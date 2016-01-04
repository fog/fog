module Fog
  module Compute
    class CloudAtCost
      class Real
        def power_off(id)
          body = { :sid => "#{id}", :action => 'poweroff' }
          request(
            :expects => [200],
            :method  => 'POST',
            :path    => 'api/v1/powerop.php',
            :body    => body,
          )
        end
      end

      class Mock
        def power_off(id)
          response         = Excon::Response.new
          response.status  = 200
          response.body    = {
            'server_id'   => Fog::Mock.random_numbers(1).to_i,
            'api'        => 'v1',
            'status'     => 'ok',
            'result'     => 'successful',
            'action'     => 'poweroff',
            'time'       => 12312323,
            'taskid'     => 123123123123
          }
          response
        end
      end
    end
  end
end
