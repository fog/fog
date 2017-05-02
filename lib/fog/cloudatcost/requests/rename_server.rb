module Fog
  module Compute
    class CloudAtCost
      class Real
        def rename_server(id, name)
          body = { :sid => "#{id}", :name => "#{name}" }
          request(
            :expects => [200],
            :method  => 'POST',
            :path    => 'api/v1/renameserver.php',
            :body    => body,
          )
        end
      end

      class Mock
        def rename_server(id, name)
          response         = Excon::Response.new
          response.status  = 200
          response.body    = {
            'server_id'   => Fog::Mock.random_numbers(1).to_i,
            'api'        => "v1",
            'status'     => "ok",
            'result'     => "successful",
            'time'       => 12312323,
          }
          response
        end
      end
    end
  end
end
