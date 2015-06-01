module Fog
  module Baremetal
    class OpenStack
      class Real
        def unset_node_maintenance(node_uuid, parameters=nil)
          if parameters
            query = parameters.each { |k, v| parameters[k] = URI::encode(v) }
          else
            query = {}
          end

          request(
            :expects => [200, 202, 204],
            :method => 'DELETE',
            :path => "nodes/#{node_uuid}/maintenance",
            :query   => query
          )
        end
      end

      class Mock
        def unset_node_maintenance(node_uuid, parameters=nil)
          response = Excon::Response.new
          response.status = 202
          response.headers = {
            "X-Compute-Request-Id" => "req-fdc6f99e-55a2-4ab1-8904-0892753828cf",
            "Content-Type" => "application/json",
            "Content-Length" => "356",
            "Date" => Date.new
          }
          response
        end
      end # mock
    end # openstack
  end # baremetal
end # fog
