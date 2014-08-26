module Fog
  module Compute
    class Cloudstack

      class Real
        # Changes the default NIC on a VM
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateDefaultNicForVirtualMachine.html]
        def update_default_nic_for_virtual_machine(nicid, virtualmachineid, options={})
          options.merge!(
            'command' => 'updateDefaultNicForVirtualMachine', 
            'nicid' => nicid, 
            'virtualmachineid' => virtualmachineid  
          )
          request(options)
        end
      end

    end
  end
end

