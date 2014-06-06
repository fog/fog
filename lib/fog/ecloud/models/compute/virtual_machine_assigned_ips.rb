require 'fog/ecloud/models/compute/virtual_machine_assigned_ip'

module Fog
  module Compute
    class Ecloud
      class VirtualMachineAssignedIps < Fog::Ecloud::Collection
        identity :virtual_machine_id

        model Fog::Compute::Ecloud::VirtualMachineAssignedIp

        def all
          data = service.get_virtual_machine_assigned_ips(self.identity).body
          load(data)
        end

        def get(uri)
          if data = service.get_virtual_machine_assigned_ip(self.identity)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
