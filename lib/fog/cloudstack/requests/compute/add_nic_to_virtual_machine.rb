module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds VM to specified network by creating a NIC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addNicToVirtualMachine.html]
        def add_nic_to_virtual_machine(virtualmachineid, networkid, options={})
          options.merge!(
            'command' => 'addNicToVirtualMachine', 
            'virtualmachineid' => virtualmachineid, 
            'networkid' => networkid  
          )
          request(options)
        end
      end

    end
  end
end

