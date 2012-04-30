module Fog
  module Compute
    class OpenStack
      class Real

        def get_quota_defaults(tenant_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/os-quota-sets/#{tenant_id}/defaults"
          )
        end

      end

      class Mock

        def get_quota_defaults(tenant_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'quota_set' => {
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
          }
          response
        end

      end

    end
  end
end
