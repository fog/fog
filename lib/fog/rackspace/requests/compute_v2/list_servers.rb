module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_servers
          request(
            :expects => [200, 203, 300],
            :method => 'GET',
            :path => 'servers/detail'
          )
        end
      end

      class Mock
        def list_servers
          servers = self.data[:servers].values.map { |s| Fog::Rackspace.keep(s, 'id', 'name', 'hostId', 'created', 'updated', 'status', 'progress', 'user_id', 'tenant_id', 'links', 'metadata') }
          response(:body => {"servers" => servers})
        end
      end
    end
  end
end
