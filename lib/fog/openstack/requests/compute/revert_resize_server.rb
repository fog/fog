module Fog
  module Compute
    class OpenStack
      class Real
        def revert_resize_server(server_id)
          body = { 'revertResize' => nil }
          server_action(server_id, body)
        end
      end

      class Mock
        def revert_resize_server(server_id)
          response = Excon::Response.new
          response.status = 202

          self.data[:servers][server_id]['flavorId'] = self.data[:servers][server_id]['old_flavorId']
          self.data[:servers][server_id].delete('old_flavorId')
          self.data[:last_modified][:servers][server_id] = Time.now
          self.data[:servers][server_id]['status'] = 'ACTIVE'

          response
        end
      end
    end
  end
end
