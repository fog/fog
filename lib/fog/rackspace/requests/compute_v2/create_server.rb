module Fog
  module Compute
    class RackspaceV2
      class Real
        # Create server
        # @param [String] name name of server
        # @param [String] image_id of the image used to create server
        # @param [String] flavor_id id of the flavor of the image
        # @param [String] min_count
        # @param [String] max_count
        # @param [Hash] options
        # @option options [Hash] metadata key value pairs of server metadata
        # @option options [String] OS-DCF:diskConfig The disk configuration value. (AUTO or MANUAL)
        # @option options [Hash] personality Hash containing data to inject into the file system of the cloud server instance during server creation.
        # @option options [Boolean] config_drive whether to attach a read-only configuration drive
        # @option options [String] keypair  Name of the kay-pair to associate with this server.
        # @option options [Array<Hash>] block_device_mapping A manually specified block device mapping to fully control the creation and
        #   attachment of volumes to this server. Mutually exclusive with :volume_id or :volume_image_id. If provided, leave image_id
        #   as "". See http://developer.openstack.org/api-ref-compute-v2-ext.html#ext-os-block-device-mapping-v2-boot for details.
        # @option options [String] boot_volume_id Id of a pre-created bootable volume to use for this server. If provided, leave image_id as "".
        # @option options [Integer] boot_volume_size Size of the bootable volume to be created expressed in GB. (defaults to 100)
        # @option options [String] boot_image_id Id of an image to create a bootable volume from and attach to this server. If provided,
        #   leave image_id as "".
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * server [Hash]:
        #       * name [String] - name of server
        #       * imageRef [String] - id of image used to create server
        #       * flavorRef [String] - id of flavor used to create server
        #       * OS-DCF:diskConfig [String] - The disk configuration value.
        #       * name [String] - name of server
        #       * metadata [Hash] - Metadata key and value pairs.
        #       * personality [Array]:
        #         * [Hash]:
        #           * path - path of the file created
        #           * contents - Base 64 encoded file contents
        #       * networks [Array]:
        #         * [Hash]:
        #           * uuid [String] - uuid of attached network
        #       * config_drive [Boolean]: Wether to use a config drive or not
        #       * user_data [String]: User data for cloud init
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateServers.html
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Server_Metadata-d1e2529.html
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Server_Personality-d1e2543.html
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ch_extensions.html#diskconfig_attribute
        # @see http://developer.openstack.org/api-ref-compute-v2-ext.html#ext-os-block-device-mapping-v2-boot
        #
        # * State Transitions
        #   * BUILD -> ACTIVE
        #   * BUILD -> ERROR (on error)
        def create_server(name, image_id, flavor_id, min_count, max_count, options = {})
          data = {
            'server' => {
              'name'      => name,
              'imageRef'  => image_id,
              'flavorRef' => flavor_id,
              'minCount'  => min_count,
              'maxCount'  => max_count
            }
          }

          data['server']['adminPass'] = options[:password] unless options[:password].nil?
          data['server']['OS-DCF:diskConfig'] = options[:disk_config] unless options[:disk_config].nil?
          data['server']['metadata'] = options[:metadata] unless options[:metadata].nil?
          data['server']['personality'] = options[:personality] unless options[:personality].nil?
          data['server']['config_drive'] = options[:config_drive] unless options[:config_drive].nil?
          data['server']['user_data'] = options[:user_data] unless options[:user_data].nil?
          data['server']['networks'] = options[:networks] || [
            { :uuid => '00000000-0000-0000-0000-000000000000' },
            { :uuid => '11111111-1111-1111-1111-111111111111' }
          ]

          if options[:keypair]
            Fog::Logger.deprecation(":keypair has been depreciated. Please use :key_name instead.")
            options[:key_name] = options[:keypair]
          end

          data['server']['key_name'] = options[:key_name] unless options[:key_name].nil?

          if options[:block_device_mapping]
            if options[:boot_volume_id]
              Fog::Logger.warning("Manual :block_device_mapping overrides :boot_volume_id in #create_server!")
            end

            if options[:boot_image_id]
              Fog::Logger.warning("Manual :block_device_mapping overrides :boot_image_id in #create_server!")
            end

            data['server']['block_device_mapping_v2'] = options[:block_device_mapping]
          else
            if options[:boot_volume_id]
              if options[:boot_image_id]
                Fog::Logger.warning(":boot_volume_id overrides :boot_image_id!")
              end

              if options[:boot_volume_size]
                Fog::Logger.warning("Boot volume size: " + options[:boot_volume_size] + "GB")
              end

              data['server']['block_device_mapping_v2'] = [{
                'boot_index' => '0',
                'uuid' => options[:boot_volume_id],
                'source_type' => 'volume',
                'destination_type' => 'volume',
                'volume_size' => options[:boot_volume_size] ? options[:boot_volume_size] : 100
              }]
            end

            if options[:boot_image_id]
              data['server']['block_device_mapping_v2'] = [{
                'boot_index' => '0',
                'uuid' => options[:boot_image_id],
                'source_type' => 'image',
                'destination_type' => 'volume',
                'volume_size' => options[:boot_volume_size] ? options[:boot_volume_size] : 100
              }]
            end
        end

          request(
            :body    => Fog::JSON.encode(data),
            :expects => [202],
            :method  => 'POST',
            :path    => "servers"
          )
        end
      end

      class Mock
        def create_server(name, image_id, flavor_id, min_count, max_count, options={})
          server_id   = Fog::Rackspace::MockData.uuid
          public_ip4  = Fog::Rackspace::MockData.ipv4_address
          public_ip6  = Fog::Rackspace::MockData.ipv6_address
          private_ip4 = Fog::Rackspace::MockData.ipv4_address
          private_ip6 = Fog::Rackspace::MockData.ipv6_address
          admin_pass  = Fog::Mock.random_letters(12)

          flavor = self.data[:flavors][flavor_id]
          image  = self.data[:images][image_id]

          server = {
            "OS-DCF:diskConfig"      => "AUTO",
            "OS-EXT-STS:power_state" => 1,
            "OS-EXT-STS:task_state"  => nil,
            "OS-EXT-STS:vm_state"    => "active",
            "accessIPv4" => public_ip4,
            "accessIPv6" => public_ip6,
            "addresses" => {
              "private" => [
                {
                  "addr" => private_ip4,
                  "version" => 4
                }
              ],
                "public" => [
                  {
                    "addr" => public_ip4,
                    "version" => 4
                  },
                  {
                    "addr" => public_ip6,
                    "version" => 6
                  }
              ]
            },
            "created" => "2012-07-28T15:32:25Z",
            "flavor" => Fog::Rackspace::MockData.keep(flavor, "id", "links"),
            "hostId" => Fog::Mock.random_hex(56),
            "id" => server_id,
            "image"  => Fog::Rackspace::MockData.keep(image, "id", "links"),
            "links" => [
              {
                "href" => "https://dfw.servers.api.rackspacecloud.com/v2/010101/servers/#{server_id}",
                "rel" => "self",
              },
              {
                "href" => "https://dfw.servers.api.rackspacecloud.com/010101/servers/#{server_id}",
                "rel" => "bookmark",
              }
            ],
            "metadata" => {},
            "name" => name,
            "progress" => 100,
            "rax-bandwidth:bandwidth" => [
              {
                "audit_period_end"   => "2012-08-16T14:12:00Z",
                "audit_period_start" => "2012-08-16T06:00:00Z",
                "bandwidth_inbound"  => 39147845,
                "bandwidth_outbound" => 13390651,
                "interface"          => "public",
              },
              {
                "audit_period_end"   => "2012-08-16T14:12:00Z",
                "audit_period_start" => "2012-08-16T06:00:00Z",
                "bandwidth_inbound"  => 24229191,
                "bandwidth_outbound" => 84,
                "interface"          => "private",
              }
            ],
            "status"             => "ACTIVE",
            "tenant_id"          => "010101",
            "updated"            => "2012-07-28T15:37:09Z",
            "user_id"            => "170454",
            :volume_ids          => [],
          }

          #  add in additional networks
          if options[:networks]
            options[:networks].each do |network|
              net_label = self.data[:networks][network[:uuid]]["label"]
              server["addresses"] = { net_label => []}
            end
          end
          self.data[:servers][server_id] = server

          response = {
            "server" => {
              "OS-DCF:diskConfig" => "AUTO",
              "adminPass" => admin_pass,
              "id" => server_id,
              "links" => [
                {
                  "href" => "https://dfw.servers.api.rackspacecloud.com/v2/010101/servers/#{server_id}",
                  "rel"  => "self"
                  },
                  {
                  "href" => "https://dfw.servers.api.rackspacecloud.com/010101/servers/#{server_id}",
                  "rel"  => "bookmark"
                }
              ]
            }
          }

          response(:body => response)
        end
      end
    end
  end
end
