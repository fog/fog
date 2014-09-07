module Fog
  module Compute
    class Cloudstack

      class Real
        # Changes the default NIC on a VM
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateDefaultNicForVirtualMachine.html]
        def update_default_nic_for_virtual_machine(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateDefaultNicForVirtualMachine') 
          else
            options.merge!('command' => 'updateDefaultNicForVirtualMachine', 
            'nicid' => args[0], 
            'virtualmachineid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

