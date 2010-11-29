module Fog
  module Rackspace
    class Compute
      class Real

        # Reboot an existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to resize
        # * size<~String> - new size. call list_flavors to get available flavors
        #
        def resize_server(server_id, flavor_id)
          body = { 'resize' => { 'flavorId' => flavor_id }}
          action(server_id, body)
        end

        # Confirm resizing
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to confirm
        #
        def confirm_resize(server_id)
          body = { 'confirmResize' => nil }
          action(server_id, body, 204)
        end

        # Revert resizing
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to revert
        #
        def revert_resize(server_id)
          body = { 'revertResize' => nil }
          action(server_id, body)
        end

      end

      class Mock

        def resize_server(server_id, flavor_id)
          response = Excon::Response.new
          response.status = 202

          #I know this is weird... but I got to keep track of it
          @data[:servers][server_id]['old_flavorId'] = @data[:servers][server_id]['flavorId']

          @data[:servers][server_id]['flavorId'] = flavor_id
          @data[:last_modified][:servers][server_id] = Time.now
          @data[:servers][server_id]['status'] = 'VERIFY_RESIZE'

          response
        end

        def confirm_resize(server_id)
          response = Excon::Response.new
          response.status = 204

          @data[:last_modified][:servers][server_id] = Time.now
          @data[:servers][server_id]['status'] = 'ACTIVE'

          response
        end

        def revert_resize(server_id)
          response = Excon::Response.new
          response.status = 202

          @data[:servers][server_id]['flavorId'] = @data[:servers][server_id]['old_flavorId']
          @data[:servers][server_id].delete('old_flavorId')
          @data[:last_modified][:servers][server_id] = Time.now
          @data[:servers][server_id]['status'] = 'ACTIVE'

          response
        end

      end
    end
  end
end
