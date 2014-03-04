module Fog
  module Compute
    class OpenStack
      class Real

        def list_hosts
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'os-hosts.json'
          )
        end

      end

      class Mock

        def list_hosts
          response = Excon::Response.new
          response.status = 200
          response.body = { "hosts" => [
              {"host_name" => "host.test.net", "service"=>"compute", "zone" => "az1"}
            ]
          }
          response
        end


      end # mock
    end # openstack
  end # compute
end # fog
