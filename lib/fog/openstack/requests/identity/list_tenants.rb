module Fog
  module Identity
    class OpenStack
      class Real
        def list_tenants(options = {})
          path = 'tenants'

          params = options.map do |key, value|
            next unless [
              'limit', 'marker', 'name', 'id'
            ].include?(key.to_s)

            "#{key}=#{value}"
          end.compact.join('&')

          path.concat("?#{params}") unless params.empty?

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => path
          )
        end
      end # class Real

      class Mock
        def list_tenants
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {
            'tenants' => [
              {'id' => '1',
               'description' => 'Has access to everything',
               'enabled' => true,
               'name' => 'admin'},
              {'id' => '2',
               'description' => 'Normal tenant',
               'enabled' => true,
               'name' => 'default'},
              {'id' => '3',
               'description' => 'Disabled tenant',
               'enabled' => false,
               'name' => 'disabled'}
            ]
          }
          response
        end # def list_tenants
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
