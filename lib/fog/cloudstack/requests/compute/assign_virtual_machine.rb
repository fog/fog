module Fog
  module Compute
    class Cloudstack

      class Real
        # Change ownership of a VM from one account to another. This API is available for Basic zones with security groups and Advanced zones with guest networks. A root administrator can reassign a VM from any account to any other account in any domain. A domain administrator can reassign a VM to any account in the same domain.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/assignVirtualMachine.html]
        def assign_virtual_machine(virtualmachineid, account, domainid, options={})
          options.merge!(
            'command' => 'assignVirtualMachine', 
            'virtualmachineid' => virtualmachineid, 
            'account' => account, 
            'domainid' => domainid  
          )
          request(options)
        end
      end

    end
  end
end

