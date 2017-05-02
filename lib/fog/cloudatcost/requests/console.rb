module Fog
  module Compute
    class CloudAtCost
      class Real
        def console(id)
          body = { :sid => "#{id}" }
          request(
            :expects => [200],
            :method  => 'POST',
            :path    => 'api/v1/console.php',
            :body    => body,
          )
        end
      end

      class Mock
        def console(id, hostname)
          response         = Excon::Response.new
          response.status  = 200
          response.body    = {
            'server_id'  => Fog::Mock.random_numbers(1).to_i,
            'api'        => 'v1',
            'status'     => 'ok',
            'console'    => 'http:\/\/panel.cloudatcost.com:12345\/console.html?servername=123456&hostname=1.1.1.1&sshkey=123456&sha1hash=aBcDeFgG',
            'time'       => 12312323,
          }
          response
        end
      end
    end
  end
end
