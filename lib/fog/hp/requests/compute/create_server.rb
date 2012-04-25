module Fog
  module Compute
    class HP
      class Real

        # Create a new server
        #
        # ==== Parameters
        # * name<~String> - Name of server
        # * flavor_id<~Integer> - Id of flavor for server
        # * image_id<~Integer> - Id of image for server
        # * options<~Hash>:
        #   * 'metadata'<~Hash> - Up to 5 key value pairs containing 255 bytes of info
        #   * 'min_count'<~Integer> - Number of servers to create. Defaults to 1.
        #   * 'max_count'<~Integer> - Max. number of servers to create. Defaults to being equal to min_count.
        #   * 'key_name'<~String> - Name of keypair to be used
        #   * 'security_groups'<~Array> - one or more security groups to be used
        #   * 'availability_zone'<~String> - the availability zone to be used
        #   * 'personality'<~Array>: Up to 5 files to customize server
        #     * file<~Hash>:
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
        #       * 'public'<~Array> - public address strings
        #       * 'private'<~Array> - private address strings
        #     * 'adminPass'<~String> - Admin password for server
        #     * 'flavorId'<~Integer> - Id of servers current flavor
        #     * 'hostId'<~String>
        #     * 'id'<~Integer> - Id of server
        #     * 'imageId'<~Integer> - Id of image used to boot server
        #     * 'metadata'<~Hash> - metadata
        #     * 'name'<~String> - Name of server
        #     * 'progress'<~Integer> - Progress through current status
        #     * 'status'<~String> - Current server status
        def create_server(name, flavor_id, image_id, options = {})
          data = {
            'server' => {
              'flavorRef'  => flavor_id,
              'imageRef'   => image_id,
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
          if options['availability_zone']
            data['server']['availability_zone'] = options['availability_zone']
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 202,
            :method   => 'POST',
            :path     => 'servers.json'
          )
        end

      end

      class Mock

        def create_server(name, flavor_id, image_id, options = {})
          response = Excon::Response.new
          response.status = 202

          #if options['security_groups']
          #  sec_group_name = options['security_groups'][0]
          #else
          #  sec_group_name = "default"
          #end
          data = {
            'addresses' => { "private"=>[{"version"=>4, "addr"=>Fog::HP::Mock.ip_address}] },
            'flavor'    => {"id"=>"#{flavor_id}", "links"=>[{"href"=>"http://nova1:8774/admin/flavors/#{flavor_id}", "rel"=>"bookmark"}]},
            'id'        => Fog::Mock.random_numbers(6).to_i,
            'image'     => {"id"=>"#{image_id}", "links"=>[{"href"=>"http://nova1:8774/admin/images/#{image_id}", "rel"=>"bookmark"}]},
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
            #'security_groups' => [{"name"=>"#{sec_group_name}", "links"=>[{"href"=>"http://nova1:8774/v1.1/admin//os-security-groups/111", "rel"=>"bookmark"}], "id"=>111}],
            'key_name'  => options['key_name'] || ""
          }
          self.data[:last_modified][:servers][data['id']] = Time.now
          self.data[:servers][data['id']] = data
          response.body = { 'server' => data.merge({'adminPass' => 'password'}) }
          response
        end

      end
    end
  end
end
