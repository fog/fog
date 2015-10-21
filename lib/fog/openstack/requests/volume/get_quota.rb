module Fog
  module Volume
    class OpenStack
      module Real
        def get_quota(tenant_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/os-quota-sets/#{tenant_id}"
          )
        end
      end

      module Mock
        def get_quota(tenant_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'quota_set' => (self.data[:quota_updated] or self.data[:quota]).merge({'id' => tenant_id})
          }
          response
        end
      end
    end
  end
end
