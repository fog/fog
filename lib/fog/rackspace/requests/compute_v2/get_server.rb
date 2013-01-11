module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_server(server_id)
          request(
            :expects => [200, 203, 300],
            :method => 'GET',
            :path => "servers/#{server_id}"
          )
        end
      end

      class Mock
        def get_server(server_id)
          server = self.data[:servers][server_id]
          if server.nil?
            raise Fog::Compute::RackspaceV2::NotFound
          else
            server_response = Fog::Rackspace.keep(server, 'id', 'name', 'hostId', 'created', 'updated', 'status', 'progress', 'user_id', 'tenant_id', 'links', 'metadata', 'accessIPv4', 'accessIPv6', 'OS-DCF:diskConfig', 'rax-bandwidth:bandwidth', 'addresses', 'flavor', 'image')
            server_response['image']['links'].map! { |l| l.delete("type"); l }
            response(:body => {"server" => server_response})
          end
        end
      end
    end
  end
end
