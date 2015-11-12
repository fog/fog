module Fog
  module Baremetal
    class OpenStack
      class Real
        def list_ports_detailed(options = {})
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => 'ports/detail',
            :query   => options
          )
        end
      end # class Real

      class Mock
        def list_ports_detailed(options = {})
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = { "ports" => self.data[:ports] }
          response
        end # def list_ports
      end # class Mock
    end # class OpenStack
  end # module Baremetal
end # module Fog
