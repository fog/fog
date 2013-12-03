module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_servers
      end
      class Mock
        def get_servers(uri)
          if uri =~ /layoutgroups/i
            group_id        = id_from_uri(uri)
            group           = self.data[:groups][group_id]
            servers         = group[:VirtualMachines][:VirtualMachine]
            compute_pool_id = servers.first[:compute_pool_id] unless servers.empty?
            compute_pool    = self.data[:compute_pools][compute_pool_id] unless compute_pool_id.nil?
          elsif uri =~ /computepool/i
            compute_pool_id = id_from_uri(uri)
            compute_pool    = self.data[:compute_pools][compute_pool_id]
            servers = self.data[:servers].values.select{|cp| cp[:compute_pool_id] == compute_pool_id}
            servers = servers.map{|server| Fog::Ecloud.slice(server, :id, :compute_pool_id)}
          end

          links = if compute_pool.nil?
                    []
                  else
                    [Fog::Ecloud.keep(compute_pool, :name, :href, :type),]
                  end

          server_response = {:VirtualMachine => (servers.size > 1 ? servers : servers.first)} # GAH
          body = {
            :href  => uri,
            :type  => "application/vnd.tmrk.cloud.virtualMachine; type=collection",
            :Links => {
              :Link => links
            }
          }.merge(server_response)

          response(:body => body)
        end
      end
    end
  end
end
