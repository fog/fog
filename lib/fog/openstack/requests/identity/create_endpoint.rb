module Fog
  module Identity
    class OpenStack
      class Real
        def create_endpoint(attributes)
          request(
            :expects => [200],
            :method  => 'POST',
            :path    => "endpoints",
            :body    => Fog::JSON.encode({ 'endpoint' => attributes })
          )
        end # def create_endpoint
      end # class Real

      class Mock
        def create_endpoint(attributes)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {
            'endpoint' => {
              'id' => "df9a815161eba9b76cc748fd5c5af73e",
              'region' => attributes[:description] || 'RegionOne',
              'publicurl' => attributes[:publicurl] || 'http://127.0.0.1/v2.0',
              'internalurl' => attributes[:internalurl] || 'http://127.0.0.1/v2.0',
              'adminurl' => attributes[:adminurl] || 'http://127.0.0.1/v2.0',
              'service_id' => "893e99a2bdc44bb6a870f7afabfbf322"
            }
          }
          response
        end # def create_endpoint
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
