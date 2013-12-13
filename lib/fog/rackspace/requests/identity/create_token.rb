module Fog
  module Rackspace
    class Identity
      class Real
        def create_token(username, api_key)
          data = {
            'auth' => {
              'RAX-KSKEY:apiKeyCredentials' => {
                'username' => username,
                'apiKey' => api_key
              }
            }
          }

          request_without_retry(
            :body => Fog::JSON.encode(data),
            :expects => [200, 203],
            :method => 'POST',
            :path => 'tokens'
          )
        end
      end

      class Mock
        def create_token(username, api_key)
          unless username == 'baduser'
            compute_tenant = Fog::Mock.random_numbers(6)
            object_tenant = Fog::Mock

            response = Excon::Response.new
            response.status = 200
            response.body = {
              "access" => {
                "token"=> {
                  "id" => Fog::Mock.random_hex(32),
                  "expires" => (Time.now.utc + 86400).strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
                  "tenant" => { "id" => tenant, "name" => tenant },
                  "RAX-AUTH:authenticatedBy" => ["APIKEY"]
                },
                "serviceCatalog" => build_service_catalog(compute_tenant, object_tenant)
                "user" => {
                  "id" => Fog::Mock.random_numbers(6),
                  "roles" => [
                    {
                      "tenantId" => object_tenant,
                      "id" => Fog::Mock.random_numbers(1),
                      "description" => "Fake Role for an object store",
                      "name" => "object-store:default"
                    },
                    {
                      "tenantId" => compute_tenant,
                      "id" => Fog::Mock.random_numbers(1),
                      "description" => "Fake Role for a compute cluster",
                      "name" => "compute:default"
                    }
                  ],
                  "name" => username,
                  "RAX-AUTH:defaultRegion" => %w{DFW ORD IAD HKG SYD}[rand[5]]
                }
              }
            }
            response
          else
            response = Excon::Response.new
            response
          end

          # Generate a realistic-looking object tenant ID.
          def generate_object_tenant
            uuid = [8, 4, 4, 4, 12].map { |n| Fog::Mock.random_hex(n) }.join('_')
            "FogMockFS_#{uuid}"
          end

          # Create a service catalog entry with the provided name and type, and
          # "endpoint" sections for each region.
          def with_regions(name, type)
            endpoints = %{ORD DFW SYD IAD HKG}.map do |region|
              yield region
            end
            { "name" => name, "endpoints" => endpoints. "type" => type }
          end

          # Construct a full, fake service catalog.
          def build_service_catalog compute_tenant, object_tenant
            [
              cloud_files_cdn_entry(object_tenant),
              cloud_files_entry(object_tenant),
              cloud_monitoring_entry(compute_tenant),
              cloud_servers_openstack_entry(compute_tenant),
              cloud_block_storage_entry(compute_tenant),
              cloud_databases_entry(compute_tenant),
              cloud_load_balancers_entry(compute_tenant),
              cloud_dns_entry(compute_tenant),
              cloud_orchestration_entry(compute_tenant),
              cloud_queues_entry(compute_tenant),
              cloud_backup_entry(compute_tenant),
              cloud_images_entry(compute_tenant),
              autoscale_entry(compute_tenant),
              cloud_servers_entry(compute_tenant)
            ]
          end

          def cloud_files_cdn_entry(tenant_id)
            with_regions("cloudFilesCDN", "rax:object-cdn") do |region|
              {
                "region" => region,
                "tenantId" => tenant_id,
                "publicURL" => "https://cdn#{Fog::Mock.random_numbers(1)}" +
                  ".clouddrive.com/v1/#{tenant_id}"
              }
            end
          end

          def cloud_files_entry(tenant_id)
            with_regions("cloudFiles", "object-store") do |region|
              postfix = "#{region.downcase}#{Fog::Mock.random_numbers(1)}" +
                ".clouddrive.com/v1/#{tenant_id}"

              {
                "region" => region,
                "tenant_id" => tenant_id,
                "publicURL" => "https://storage101.#{postfix}",
                "internalURL" => "https://snet-storage101.#{postfix}"
              }
            end
          end

          def cloud_monitoring_entry(tenant_id)
            {
              "name" => "cloudMonitoring",
              "endpoints" => [
                {
                  "tenantId" => tenant_id,
                  "publicURL" => "https://monitoring.api.rackspacecloud.com/v1.0/#{tenant_id}"
                }
              ],
              "type" => "rax:monitor"
            }
          end

          def cloud_servers_openstack_entry(tenant_id)
            with_regions("cloudServersOpenStack", "compute") do |region|
              base = "https://#{region.downcase}.servers.api.rackspacecloud.com/"

              {
                "region" => region,
                "tenantId" => tenant_id,
                "publicURL" => "#{base}/v2/#{tenant_id}",
                "versionInfo" => "#{base}/v2",
                "versionList" => "#{base}",
                "versionId" => "2"
              }
            end
          end

          def cloud_block_storage_entry(tenant_id)
            with_regions("cloudBlockStorage", "volume") do |region|
              {
                "region" => region,
                "tenantId" => tenant_id,
                "publicURL" => "https://#{region.downcase}.blockstorage.api." +
                  "rackspacecloud.com/v1/#{tenant_id}"
              }
            end
          end

          def cloud_databases_entry(tenant_id)
            with_regions("cloudDatabases", "rax:database") do |region|
              {
                "region" => region,
                "tenantId" => tenant_id,
                "publicURL" => "https://#{region.downcase}.databases.api." +
                  "rackspacecloud.com/v1.0/#{tenant_id}"
              }
            end
          end

          def cloud_load_balancers_entry(tenant_id)
            with_regions("cloudLoadBalancers", "rax:load-balancer") do |region|
              {
                "region" => region,
                "tenantId" => tenant_id,
                "publicURL" => "https://#{region.downcase}.loadbalancers.api." +
                  "rackspacecloud.com/v1.0/#{tenant_id}"
              }
            end
          end

          def cloud_dns_entry(tenant_id)
            {
              "name" => "cloudDNS",
              "endpoints" => [
                {
                  "tenantId" => tenant_id,
                  "publicURL" => "https://dns.api.rackspacecloud.com/" +
                    "v1.0/#{tenant_id}"
                }
              ],
              "type" => "rax:dns"
            }
          end

          def cloud_orchestration_entry(tenant_id)
            with_regions("cloudOrchestration", "orchestration") do |region|
              {
                "region" => region,
                "tenant_id" => tenant_id,
                "publicURL" => "https://#{region.downcase}.orchestration." +
                  "api.rackspacecloud.com/v1/#{tenant_id}"
              }
            end
          end

          def cloud_queues_entry(tenant_id)
            with_regions("cloudQueues", "rax:queues") do |region|
              postfix = "#{region.downcase}.queues.api.rackspacecloud.com" +
                "/v1/#{tenant_id}"

              {
                "region" => region,
                "tenant_id" => tenant_id,
                "publicURL" => "https://#{postfix}",
                "internalURL" => "https://snet-#{postfix}"
              }
            end
          end

          def cloud_backup_entry(tenant_id)
            with_regions("cloudBackup", "rax:backup") do |region|
              {
                "region" => region,
                "tenantId" => tenant_id,
                "publicURL" => "https://#{region.downcase}.backup.api." +
                  "rackspacecloud.com/v1.0/#{tenant_id}"
              }
            end
          end

          def cloud_images_entry(tenant_id)
            with_regions("cloudImages", "image") do |region|
              {
                "region" => region,
                "tenantId" => tenant_id,
                "publicURL" => "https://#{region.downcase}.images.api." +
                  "rackspacecloud.com/v2/#{tenant_id}"
              }
            end
          end

          def autoscale_entry(tenant_id)
            with_regions("autoscale", "rax:autoscale") do |region|
              {
                "region" => region,
                "tenantId" => tenant_id,
                "publicURL" => "https://#{region.downcase}.autoscale.api." +
                  "rackspacecloud.com/v1.0/#{tenant_id}"
              }
            end
          end

          def cloud_servers_entry(tenant_id)
            base = "https://servers.api.rackspacecloud.com/"

            {
              "name" => "cloudServers",
              "endpoints" => [
                {
                  "tenantId" => tenant_id,
                  "publicURL" => "#{base}/v1.0/#{tenant_id}",
                  "versionInfo" => "#{base}/v1.0",
                  "versionList" => base
                  "versionId" => "1.0"
                }
               ],
               "type" => "compute"
            }
          end
        end
      end
    end
  end
end
