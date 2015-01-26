module Fog
  module Network
    class OpenStack
      class Real
        def update_quota(tenant_id, options = {})
          request(
            :body     => Fog::JSON.encode({ 'quota' => options} ),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "/quotas/#{tenant_id}"
          )
        end
      end

      class Mock
        def update_quota(tenant_id, options = {})
          self.data[:quota_updated] = self.data[:quota].merge options

          response = Excon::Response.new
          response.status = 200
          response.body = { 'quota' => self.data[:quota_updated] }
          response
        end
      end
    end
  end
end
