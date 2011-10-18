module Fog
  module Compute
    class Rackspace
      class Real

        # Reboot an existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to resize
        # * size<~String> - new size. call list_flavors to get available flavors
        #
        def resize_server(server_id, flavor_id)
          body = { 'resize' => { 'flavorId' => flavor_id }}
          server_action(server_id, body)
        end

      end

      class Mock

        # FIXME: should probably transition instead of skipping to VERIFY_RESIZE
        def resize_server(server_id, flavor_id)
          response = Excon::Response.new
          response.status = 202

          # keep track of this for reverts
          self.data[:servers][server_id]['old_flavorId'] = self.data[:servers][server_id]['flavorId']

          self.data[:servers][server_id]['flavorId'] = flavor_id
          self.data[:last_modified][:servers][server_id] = Time.now
          self.data[:servers][server_id]['status'] = 'VERIFY_RESIZE'

          response
        end

      end
    end
  end
end
