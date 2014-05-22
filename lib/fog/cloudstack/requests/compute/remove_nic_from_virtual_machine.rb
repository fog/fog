module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes VM from specified network by deleting a NIC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeNicFromVirtualMachine.html]
        def remove_nic_from_virtual_machine(options={})
          options.merge!(
            'command' => 'removeNicFromVirtualMachine',
            'virtualmachineid' => options['virtualmachineid'], 
            'nicid' => options['nicid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

