module Fog
  module Compute
    class Ecloud
      class Real
        def get_virtual_machine_assigned_ips(virtual_machine_id)
          request(
            :uri => "#{base_path}/virtualmachines/#{virtual_machine_id}/assignedips",
            :parse   => true
          )
        end
      end

      class Mock
        def get_virtual_machine_assigned_ips(virtual_machine_id)
          server         = self.data[:servers][virtual_machine_id.to_i]
          compute_pool   = self.data[:compute_pools][server[:compute_pool_id]]
          environment_id = compute_pool[:environment_id]
          environment    = self.data[:environments][environment_id]

          networks = self.data[:networks].values.select{|n| n[:environment_id] == environment_id}
          networks = networks.map{|n| deep_copy(Fog::Ecloud.slice(n, :environment, :id))}

          networks.each do |network|
            address = network[:IpAddresses][:IpAddress].map{|ia| ia[:name]}
            network[:IpAddresses][:IpAddress] = address.first
          end

          body = {
            :href  => "/cloudapi/ecloud/virtualMachines/#{virtual_machine_id}/assignedIps",
            :type  => "application/vnd.tmrk.cloud.network",
            :Links => {
              :Link => Fog::Ecloud.keep(environment, :name, :href, :type)
            },
            :Networks => {:Network => (networks.size > 1 ? networks : networks.first)},
          }

          response(:body =>  body)
        end
      end
    end
  end
end
