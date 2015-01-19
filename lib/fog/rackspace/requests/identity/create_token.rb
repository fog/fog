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
          unless username == 'baduser' || api_key == 'bad_key'
            compute_tenant = Fog::Mock.random_numbers(6)
            object_tenant = generate_object_tenant

            response = Excon::Response.new
            response.status = 200
            response.body = {
              "access" => {
                "token"=> {
                  "id" => Fog::Mock.random_hex(32),
                  "expires" => (Time.now.utc + 86400).strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
                  "tenant" => { "id" => compute_tenant, "name" => compute_tenant }
                },
                "user" => {
                  "id" => Fog::Mock.random_numbers(6),
                  "name" => username,
                  "roles" => [
                    {
                      "id" => Fog::Mock.random_numbers(1),
                      "description" => "Fake Role for an object store",
                      "name" => "object-store:default"
                    },
                    {
                      "id" => Fog::Mock.random_numbers(1),
                      "description" => "Fake Role for a compute cluster",
                      "name" => "compute:default"
                    }
                  ]
                },
                "serviceCatalog" => build_service_catalog(compute_tenant, object_tenant),
              }
            }
            response
          else
            response = Excon::Response.new
            response.status = 401
            response.body = {
              "unauthorized" => {
                "code" => 401,
                "message" => "Username or API key is invalid."
              }
            }
            raise Excon::Errors::Unauthorized.new('Unauthorized', nil, response)
          end
        end

        # Generate a realistic-looking object tenant ID.
        def generate_object_tenant
          uuid = [8, 4, 4, 4, 12].map { |n| Fog::Mock.random_hex(n) }.join('_')
          "FogMockFS_#{uuid}"
        end

        # Construct a full, fake service catalog.
        #
        # @param compute_tenant [String] Tenant ID to be used in entries for
        #   compute-based services (most of them).
        # @param object_tenant [String] Tenant ID to be used in object-store
        #   related entries.
        #
        # @return [Hash] A fully-populated, valid service catalog.
        def build_service_catalog(compute_tenant, object_tenant)
          [
            service_catalog_entry("cloudFilesCDN", "rax:object-cdn", object_tenant,
              :public_url => lambda do |r|
                "https://cdn#{Fog::Mock.random_numbers(1)}.clouddrive.com/v1/#{object_tenant}"
              end),

            service_catalog_entry("cloudFiles", "object-store", object_tenant,
              :internal_url_snet => true,
              :public_url => lambda do |r|
                "https://storage101.#{r}#{Fog::Mock.random_numbers(1)}.clouddrive.com/v1/#{object_tenant}"
              end),

            service_catalog_entry("rackCDN", "rax:cdn", compute_tenant, :rackspace_api_version => '1.0'),

            service_catalog_entry("cloudMonitoring", "rax:monitor", compute_tenant,
              :single_endpoint => true, :rackspace_api_name => 'monitoring'),

            service_catalog_entry("cloudServersOpenStack", "compute", compute_tenant,
              :version_base_url => lambda { |r| "https://#{r}.servers.api.rackspacecloud.com" },
              :version_id => "2"),

            service_catalog_entry("cloudBlockStorage", "volume", compute_tenant,
              :rackspace_api_name => 'blockstorage', :rackspace_api_version => '1'),

            service_catalog_entry("cloudDatabases", "rax:database", compute_tenant,
              :rackspace_api_name => 'databases'),

            service_catalog_entry("cloudLoadBalancers", "rax:load-balander", compute_tenant,
              :rackspace_api_name => 'loadbalancers'),

            service_catalog_entry("cloudDNS", "rax:dns", compute_tenant,
              :single_endpoint => true, :rackspace_api_name => 'dns'),

            service_catalog_entry("cloudOrchestration", "orchestration", compute_tenant,
              :rackspace_api_name => 'orchestration', :rackspace_api_version => '1'),

            service_catalog_entry("cloudNetworks", "network", compute_tenant,
              :rackspace_api_name => 'networks', :rackspace_api_version => '2.0'),

            service_catalog_entry("cloudQueues", "rax:queues", compute_tenant,
              :internal_url_snet => true,
              :rackspace_api_name => 'queues', :rackspace_api_version => '1'),

            service_catalog_entry("cloudBackup", "rax:backup", compute_tenant,
              :rackspace_api_name => 'backup'),

            service_catalog_entry("cloudImages", "image", compute_tenant,
              :rackspace_api_name => 'images', :rackspace_api_version => '2'),

            service_catalog_entry("autoscale", "rax:autoscale", compute_tenant,
              :rackspace_api_name => 'autoscale'),

            service_catalog_entry("cloudServers", "compute", compute_tenant,
              :single_endpoint => true,
              :version_base_url => lambda { |r| "https://servers.api.rackspacecloud.com" },
              :version_id => '1.0')
          ]
        end

        # Generate an individual service catalog entry for a fake service
        # catalog. Understands common patterns used within Rackspace
        # service catalogs.
        #
        # @param name [String] The required "name" attribute of the
        #   service catalog entry.
        # @param type [String] The required "type" attribute.
        # @param tenant_id [String] Tenant ID to be used for this service.
        #
        # @param options [Hash] Control the contents of the generated entry.
        # @option options [Proc] :public_url Callable invoked with each region
        #    (or `nil`) to generate a `publicURL` for that region.
        # @option options [Boolean] :single_endpoint If `true`, only a single
        #    endpoint entry will be generated, rather than an endpoint for each
        #    region.
        # @option options [Boolean] :internal_url_snet If `true`, an internalURL
        #    entry will be generated by prepending "snet-" to the publicURL.
        # @option options [String] :rackspace_api_name If specified, will generate
        #    publicURL as a Rackspace API URL.
        # @option options [String] :rackspace_api_version (`"1.0"`) Specify the
        #    version of the Rackspace API URL.
        #
        # @return [Hash] A valid service catalog entry.
        def service_catalog_entry(name, type, tenant_id, options)
          if options[:rackspace_api_name]
            api_name = options[:rackspace_api_name]
            api_version = options[:rackspace_api_version] || "1.0"
            options[:public_url] = lambda do |r|
              prefix = r ? "#{r}." : ""
              "https://#{prefix}#{api_name}.api.rackspacecloud.com/v#{api_version}/#{tenant_id}"
            end
          end

          entry = { "name" => name, "type" => type }
          if options[:single_endpoint]
            entry["endpoints"] = [endpoint_entry(tenant_id, nil, options)]
          else
            entry["endpoints"] = %w{ORD DFW SYD IAD HKG}.map do |region|
              endpoint_entry(tenant_id, region, options)
            end
          end
          entry
        end

        # Helper method that generates a single endpoint hash within a service
        # catalog entry.
        #
        # @param tenant_id [String] The tenant ID used for this endpoint.
        # @param region [String, nil] The region to include in this endpoint, if any.
        # @param options [Hash] Options inherited from {#service_catalog_entry}.
        #
        # @return [Hash] A well-formed endpoint hash.
        def endpoint_entry(tenant_id, region, options)
          endpoint = { "tenantId" => tenant_id }
          endpoint["region"] = region if region
          r = region.downcase if region
          endpoint["publicURL"] = options[:public_url].call(r) if options[:public_url]

          if options[:internal_url_snet]
            endpoint["internalURL"] = endpoint["publicURL"].gsub(%r{^https://}, "https://snet-")
          end

          endpoint["internalURL"] = options[:internal_url].call(r) if options[:internal_url]
          if options[:version_base_url] && options[:version_id]
            base = options[:version_base_url].call(r)
            version = options[:version_id]
            endpoint["publicURL"] = "#{base}/v#{version}/#{tenant_id}"
            endpoint["versionInfo"] = "#{base}/v#{version}"
            endpoint["versionList"] = base
            endpoint["versionId"] = version
          end
          endpoint
        end
      end
    end
  end
end
