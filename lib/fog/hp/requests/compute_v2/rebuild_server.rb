module Fog
  module Compute
    class HPV2
      class Real
        # Rebuild an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to rebuild
        # * 'image_id'<~String> - UUId of image to use to rebuild server
        # * 'name'<~String> - New name for the rebuilt server
        # * 'admin_pass'<~String> - Password for the rebuilt server
        # * options<~Hash>:
        #   * 'metadata'<~Hash> - Up to 5 key value pairs containing 255 bytes of info
        #   * 'accessIPv4'<~String> - IPv4 IP address
        #   * 'accessIPv6'<~String> - IPv6 IP address
        #   * 'personality'<~Array>: Up to 5 files to customize server
        #     * 'file'<~Hash>:
        #       * 'contents'<~String> - Contents of file (10kb total of contents)
        #       * 'path'<~String> - Path to file (255 bytes total of path strings)
        def rebuild_server(server_id, image_id, name, options={})
          body = { 'rebuild' => {
            'imageRef' => image_id,
            'name' => name
          }}
          l_options = ['metadata', 'accessIPv4', 'accessIPv6']
          l_options.select{|o| options[o]}.each do |key|
            body['rebuild'][key] = options[key]
          end
          if options['personality']
            body['rebuild']['personality'] = []
            for file in options['personality']
              body['rebuild']['personality'] << {
                'contents'  => Base64.encode64(file['contents']),
                'path'      => file['path']
              }
            end
          end
          server_action(server_id, body, 202)
        end
      end

      class Mock
        def rebuild_server(server_id, image_id, name, options={})
          if image = list_images_detail.body['images'].find {|_| _['id'] == image_id}
            if response = get_server_details(server_id)
              response.body['server']['name'] = name
              response.body['server']['image']['id'] = image_id
              response.body['server']['image']['name'] = image['name']
              response.body['server']['image']['links'] = image['links']
              response.body['server']['status'] = 'REBUILD'
              l_options = ['metadata', 'accessIPv4', 'accessIPv6']
              l_options.select{|o| options[o]}.each do |key|
                response.body['server'][key] = options[key] || ''
              end
              # personality files are wiped off while rebuilding
              response.body['server']['personality'] = []
              if options['personality']
                for file in options['personality']
                  response.body['server']['personality'] << {
                    'contents'  => Base64.encode64(file['contents']),
                    'path'      => file['path']
                  }
                end
              end
              response.status = 202
              response
            else
              raise Fog::Compute::HPV2::NotFound
            end
          else
            raise Fog::Compute::HPV2::NotFound.new("Image with image_id #{image_id} not found.")
          end
        end
      end
    end
  end
end
