module Fog
  module Baremetal
    class OpenStack
      class Real
        def list_nodes(parameters=nil)
          if parameters
            query = parameters.each { |k, v| parameters[k] = URI::encode(v) }
          else
            query = {}
          end

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => 'nodes',
            :query   => query
          )
        end
      end # class Real

      class Mock
        def list_nodes(parameters=nil)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {
            "nodes" => [{
              "instance_uuid"    => Fog::UUID.uuid,
              "maintenance"      => false,
              "power_state"      => "power on",
              "provision_state"  => "active",
              "uuid"             => Fog::UUID.uuid,
              "links"            => []
            }]
          }
          response
        end # def list_nodes
      end # class Mock
    end # class OpenStack
  end # module Baremetal
end # module Fog
