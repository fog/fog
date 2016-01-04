module Fog
  module Compute
    class CloudAtCost
      class Real
        def create_server(cpu, ram, storage, template_id)
          body = { cpu: "#{cpu}", ram: "#{ram}", storage: "#{storage}", os: "#{template_id}" }
          request(
            :expects => [200],
            :method  => 'POST',
            :path    => 'api/v1/cloudpro/build.php',
            :body    => body,
          )
        end
      end

      class Mock
        def create_server(cpu, ram, storage, template_id)
          response         = Excon::Response.new
          response.status  = 200
          response.body    = {
            'result'     => 'successful',
            'api'        => 'v1',
            'action'     => 'build',
            'status'     => 'ok',
            'taskid'     => 123123123123,
            'time'       => 12312323,
          }
          response
        end
      end
    end
  end
end
