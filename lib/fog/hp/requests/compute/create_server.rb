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
            :body     => MultiJson.encode(data),
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

          data = {
            'addresses' => { "novanet_7"=>[{"version"=>4, "addr"=>Fog::HP::Mock.ip_address}] },
            'flavor'    => {"id"=>"1", "links"=>[{"href"=>"http://nova1:8774/admin/flavors/1", "rel"=>"bookmark"}]},
            'id'        => Fog::Mock.random_numbers(6).to_s,
            'image'     => {"id"=>"3", "links"=>[{"href"=>"http://nova1:8774/admin/images/3", "rel"=>"bookmark"}]},
            'links'     => [{"href"=>"http://nova1:8774/v1.1/admin/servers/5", "rel"=>"self"}, {"href"=>"http://nova1:8774/admin/servers/5", "rel"=>"bookmark"}],
            'hostId'    => "123456789ABCDEF01234567890ABCDEF",
            'metadata'  => options['metadata'] || {},
            'name'      => name || "server_#{rand(999)}",
            'accessIPv4'  => options['accessIPv4'] || "",
            'accessIPv6'  => options['accessIPv6'] || "",
            'progress'  => 0,
            'status'    => 'BUILD',
            'user_id'   => Fog::HP::Mock.user_id.to_s,
            'tenant_id' => Fog::HP::Mock.user_id.to_s,
            'key_name'  => options['key_name'] || "",
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
