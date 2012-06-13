module Fog
  module Compute
    class OpenStack
      class Real

        def update_quota(tenant_id, options = {})
          options['tenant_id'] = tenant_id
          request(
            :body => MultiJson.encode({ 'quota_set' => options }),
            :expects => 200,
            :method => 'PUT',
            :path => "/os-quota-sets/#{tenant_id}"
          )
        end

      end

      class Mock

        def update_quota(tenant_id, options = {})
          defaults = {
            'metadata_items' => 128,
            'injected_file_content_bytes' => 10240,
            'injected_files' => 5,
            'gigabytes' => 1000,
            'ram' => 51200,
            'floating_ips' => 10,
            'instances' => 10,
            'volumes' => 10,
            'cores' => 20,
            'id' => tenant_id
          }

          defaults.merge options

          response = Excon::Response.new
          response.status = 200
          response.body = { 'quota_set' => options }
          response
        end

      end
    end
  end
end
