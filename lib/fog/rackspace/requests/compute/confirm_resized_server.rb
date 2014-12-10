module Fog
  module Compute
    class Rackspace
      class Real
        # Confirm resizing
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to confirm
        #
        def confirm_resized_server(server_id)
          body = { 'confirmResize' => nil }
          server_action(server_id, body, 204)
        end
      end

      class Mock
        def confirm_resized_server(server_id)
          response = Excon::Response.new
          response.status = 204

          self.data[:servers][server_id].delete('old_flavorId')
          self.data[:last_modified][:servers][server_id] = Time.now
          self.data[:servers][server_id]['status'] = 'ACTIVE'

          response
        end
      end
    end
  end
end
