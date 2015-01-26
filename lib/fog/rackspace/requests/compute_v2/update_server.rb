module Fog
  module Compute
    class RackspaceV2
      class Real
        # Update the editable attributes of a specified server.
        # @param [String] server_id
        # @param [Hash] options
        # @option options [Hash] name name for server
        # @option options [String] accessIPv4 The IP version 4 address.
        # @option options [Hash] accessIPv6 The IP version 6 address.
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @note If you edit the server name, the server host name does not change. Also, server names are not guaranteed to be unique.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ServerUpdate.html
        def update_server(server_id, options={})
          data = options.is_a?(Hash) ? options : { 'name' => options } #LEGACY - second parameter was previously server name

          request(
            :body => Fog::JSON.encode('server' => data),
            :expects => [200],
            :method => 'PUT',
            :path => "servers/#{server_id}"
          )
        end
      end

      class Mock
        def update_server(server_id, name)
          server          = self.data[:servers][server_id]
          name.each_pair {|k,v| server[k] = v } if name.is_a?(Hash)
          server['name']  = name if name.is_a?(String)
          server_response = Fog::Rackspace::MockData.keep(server, 'id', 'name', 'hostId', 'created', 'updated', 'status', 'progress', 'user_id', 'tenant_id', 'links', 'metadata', 'accessIPv4', 'accessIPv6', 'OS-DCF:diskConfig', 'rax-bandwidth:bandwidth', 'addresses', 'flavor', 'links', 'image')

          response(
            :status => 200,
            :body   => {'server' => server_response}
          )
        end
      end
    end
  end
end
