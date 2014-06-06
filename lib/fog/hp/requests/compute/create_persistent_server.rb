module Fog
  module Compute
    class HP
      class Real
        # Create a new persistent server i.e. use a bootable volume instead of an image
        #
        # ==== Parameters
        # * name<~String> - Name of server
        # * flavor_id<~Integer> - Id of flavor for server
        # * block_device_mapping<~Array>: Use bootable volumes to create persistent instances
        #   * <~Hash>:
        #     * 'volume_size'<~String> - Size of the volume. Ignored, and automatically picked up from the volume
        #     * 'volume_id'<~String> - Id of the bootable volume to use
        #     * 'delete_on_termination'<~String> - Setting this to '1' (True) means that the volume gets deleted when the instance is killed. Set it to '0' to preserve the volume.
        #     * 'device_name'<~String> - Block device name e.g. "vda"
        # * options<~Hash>:
        #   * 'metadata'<~Hash> - Up to 5 key value pairs containing 255 bytes of info
        #   * 'min_count'<~Integer> - Number of servers to create. Defaults to 1.
        #   * 'max_count'<~Integer> - Max. number of servers to create. Defaults to being equal to min_count.
        #   * 'key_name'<~String> - Name of keypair to be used
        #   * 'security_groups'<~Array> - one or more security groups to be used
        #   * 'personality'<~Array>: Up to 5 files to customize server
        #     * 'file'<~Hash>:
        #       * 'contents'<~String> - Contents of file (10kb total of contents)
        #       * 'path'<~String> - Path to file (255 bytes total of path strings)
        #   * 'accessIPv4'<~String> - IPv4 IP address
        #   * 'accessIPv6'<~String> - IPv6 IP address
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'server'<~Hash>:
        #     * 'addresses'<~Hash>:
        #       * 'private'<~Array> - private and public fixed and floating ip addresses
        #     * 'flavor'<~Hash>
        #       * 'id'<~String> - id of the flavor
        #       * 'links'<~Array> - array of flavor links
        #     * 'id'<~Integer> - id of server
        #     * 'links'<~Array> - array of server links
        #     * 'hostId'<~String>
        #     * 'metadata'<~Hash> - metadata
        #     * 'name'<~String> - name of server
        #     * 'accessIPv4'<~String> - IPv4 ip address
        #     * 'accessIPv6'<~String> - IPv6 ip address
        #     * 'progress'<~Integer> - progress through current status
        #     * 'status'<~String> - current server status
        #     * 'created'<~String> - created date time stamp
        #     * 'updated'<~String> - updated date time stamp
        #     * 'user_id'<~String> - user id
        #     * 'tenant_id'<~String> - tenant id
        #     * 'uuid'<~String> - uuid of the server
        #     * 'config_drive'<~String> - config drive
        #     * 'security_groups'<~Array of Hash>
        #       * 'id'<~Integer> - id of the security group
        #       * 'name'<~String> - name of the security group
        #       * 'links'<~Array> - array of security group links
        #     * 'key_name'<~String> - name of the keypair
        #     * 'adminPass'<~String> - admin password for server
        def create_persistent_server(name, flavor_id, block_device_mapping = [], options = {})
          data = {
            'server' => {
              'flavorRef'  => flavor_id,
              'imageRef'   => nil,
              'name'       => name
            }
          }
          if options['metadata']
            data['server']['metadata'] = options['metadata']
          end
          if options['accessIPv4']
            data['server']['accessIPv4'] = options['accessIPv4']
          end
          if options['accessIPv6']
            data['server']['accessIPv6'] = options['accessIPv6']
          end
          if options['personality']
            data['server']['personality'] = []
            for file in options['personality']
              data['server']['personality'] << {
                'contents'  => Base64.encode64(file['contents']),
                'path'      => file['path']
              }
            end
          end
          min_count = options['min_count'] || 1
          max_count = options['max_count'] || min_count
          data['server']['min_count'] = min_count
          data['server']['max_count'] = max_count

          if options['key_name']
            data['server']['key_name'] = options['key_name']
          end
          if options['security_groups']
            data['server']['security_groups'] = []
            for sg in options['security_groups']
              data['server']['security_groups'] << {
                'name' => sg
              }
            end
          end
          if options['config_drive']
            data['server']['config_drive'] = options['config_drive']
          end
          if block_device_mapping
            data['server']['block_device_mapping'] = block_device_mapping
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-volumes_boot'
          )
        end
      end

      class Mock
        def create_persistent_server(name, flavor_id, block_device_mapping = [], options = {})
          response = Excon::Response.new

          if block_device_mapping && !block_device_mapping.empty?

            if options['security_groups']
              sec_group_name = options['security_groups'][0]
            else
              sec_group_name = "default"
            end

            data = {
              'addresses' => { "private"=>[{"version"=>4, "addr"=>Fog::HP::Mock.ip_address}] },
              'flavor'    => {"id"=>"#{flavor_id}", "links"=>[{"href"=>"http://nova1:8774/admin/flavors/#{flavor_id}", "rel"=>"bookmark"}]},
              'id'        => Fog::Mock.random_numbers(6).to_i,
              'links'     => [{"href"=>"http://nova1:8774/v1.1/admin/servers/5", "rel"=>"self"}, {"href"=>"http://nova1:8774/admin/servers/5", "rel"=>"bookmark"}],
              'hostId'    => "123456789ABCDEF01234567890ABCDEF",
              'metadata'  => options['metadata'] || {},
              'name'      => name || "server_#{rand(999)}",
              'accessIPv4'  => options['accessIPv4'] || "",
              'accessIPv6'  => options['accessIPv6'] || "",
              'progress'  => 0,
              'status'    => 'BUILD',
              'created'   => "2012-01-01T13:32:20Z",
              'updated'   => "2012-01-01T13:32:20Z",
              'user_id'   => Fog::HP::Mock.user_id.to_s,
              'tenant_id' => Fog::HP::Mock.user_id.to_s,
              'uuid'      => "95253a45-9ead-43c6-90b3-65da2ef048b3",
              'config_drive' => "",
              'security_groups' => [{"name"=>"#{sec_group_name}", "links"=>[{"href"=>"http://nova1:8774/v1.1/admin//os-security-groups/111", "rel"=>"bookmark"}], "id"=>111}],
              'key_name'  => options['key_name'] || ""
            }
            self.data[:last_modified][:servers][data['id']] = Time.now
            self.data[:servers][data['id']] = data
            response.body = { 'server' => data.merge({'adminPass' => 'password'}) }
            response.status = 200
            response
          else
            response.status = 400
            raise(Excon::Errors::BadRequest, "No boot volume or boot image specified")
          end
        end
      end
    end
  end
end
