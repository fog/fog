module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds VM to specified network by creating a NIC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addNicToVirtualMachine.html]
        def add_nic_to_virtual_machine(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addNicToVirtualMachine') 
          else
            options.merge!('command' => 'addNicToVirtualMachine', 
            'virtualmachineid' => args[0], 
            'networkid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

