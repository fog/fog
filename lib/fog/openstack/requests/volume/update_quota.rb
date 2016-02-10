module Fog
  module Volume
    class OpenStack
      module Real
        def update_quota(tenant_id, options = {})
          options['tenant_id'] = tenant_id
          request(
            :body => Fog::JSON.encode({ 'quota_set' => options }),
            :expects => 200,
            :method => 'PUT',
            :path => "/os-quota-sets/#{tenant_id}"
          )
        end
      end

      module Mock
        def update_quota(tenant_id, options = {})
          self.data[:quota_updated] = self.data[:quota].merge options

          response = Excon::Response.new
          response.status = 200
          response.body = { 'quota_set' => self.data[:quota_updated] }
          response
        end
      end
    end
  end
end
