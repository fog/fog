module Fog
  module Baremetal
    class OpenStack
      class Real
        def list_ports_detailed(parameters=nil)
          if parameters
            query = parameters.each { |k, v| parameters[k] = URI::encode(v) }
          else
            query = {}
          end

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => 'ports/detail',
            :query   => query
          )
        end
      end # class Real

      class Mock
        def list_ports_detailed(parameters=nil)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = { "ports" => self.data[:ports] }
          response
        end # def list_ports
      end # class Mock
    end # class OpenStack
  end # module Baremetal
end # module Fog
