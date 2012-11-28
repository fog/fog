module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_servers
      end
      class Mock
        def get_servers(uri)
          compute_pool_id = id_from_uri(uri)
          compute_pool    = self.data[:compute_pools][compute_pool_id]

          servers = self.data[:servers].values.select{|cp| cp[:compute_pool_id] == compute_pool_id}
          servers = servers.map{|server| Fog::Ecloud.slice(server, :id, :compute_pool_id)}

          server_response = {:VirtualMachine => (servers.size > 1 ? servers : servers.first)} # GAH
          body = {
            :href  => uri,
            :type  => "application/vnd.tmrk.cloud.virtualMachine; type=collection",
            :Links => {
              :Link => Fog::Ecloud.keep(compute_pool, :name, :href, :type),
            }
          }.merge(server_response)

          response(:body => body)
        end
      end
    end
  end
end
