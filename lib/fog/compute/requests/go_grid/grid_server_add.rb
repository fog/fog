module Fog
  module GoGrid
    class Compute
      class Real

        # Create a new server
        #
        # ==== Parameters
        # * 'name'<~String>   - name of the server, 20 or fewer characters
        # * 'image'<~String>  - image to use, in grid_image_list
        # * 'ip'<~String> - initial public ip for this server
        # * 'options'<~Hash>:
        #   * 'server.ram'<~String> - flavor to use, in common_lookup_list('server.ram')
        #   * 'description'<~String>  - description of this server
        #   * 'isSandbox'<~String>    - treat this server as image sandbox? in ['true', 'false']
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def grid_server_add(name, image, ip, options={})
          request(
            :path     => 'grid/server/add',
            :query    => {
              'image'       => image,
              'ip'          => ip,
              'name'        => name,
            }.merge!(options)
          )
        end

      end

      class Mock

        def grid_server_add(image, ip, name, server_ram, options={})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
