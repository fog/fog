module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes VM from specified network by deleting a NIC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/removeNicFromVirtualMachine.html]
        def remove_nic_from_virtual_machine(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'removeNicFromVirtualMachine') 
          else
            options.merge!('command' => 'removeNicFromVirtualMachine', 
            'virtualmachineid' => args[0], 
            'nicid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

