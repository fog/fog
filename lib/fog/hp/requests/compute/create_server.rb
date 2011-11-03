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
        #   * 'name'<~String> - Name of server, defaults to "slice#{id}"
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
            'addresses' => { 'private' => ['0.0.0.0'], 'public' => ['0.0.0.0'] },
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
            'status'    => 'BUILD'
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
