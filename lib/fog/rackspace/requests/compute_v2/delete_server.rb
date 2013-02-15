module Fog
  module Compute
    class RackspaceV2
      class Real
        
        # Deletes a specified server instance from the system.
        # @param [String] server_id the id of the server to delete
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Delete_Server-d1e2883.html
        def delete_server(server_id)
          request(
            :expects => [204],
            :method => 'DELETE',
            :path => "servers/#{server_id}"
          )
        end
      end

      class Mock
        def delete_server(server_id)
          self.data[:servers].delete(server_id)
          volumes = self.data[:volumes].values
          volumes.each do |v|
            v["attachments"].delete_if { |a| a["serverId"] == server_id }
            v["status"] = "available" if v["attachments"].empty?
          end
          response(:status => 204)
        end
      end
    end
  end
end
