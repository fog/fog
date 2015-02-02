module Fog
  module Baremetal
    class OpenStack
      class Real
        def list_chassis_detailed(parameters=nil)
          if parameters
            query = parameters.each { |k, v| parameters[k] = URI::encode(v) }
          else
            query = {}
          end

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => 'chassis/detail',
            :query   => query
          )
        end
      end # class Real

      class Mock
        def list_chassis_detailed(parameters=nil)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = { "chassis" => self.data[:chassis_collection] }
          response
        end # def list_chassis_detailed
      end # class Mock
    end # class OpenStack
  end # module Baremetal
end # module Fog
