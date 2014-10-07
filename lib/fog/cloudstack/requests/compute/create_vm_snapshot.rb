module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates snapshot for a vm.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createVMSnapshot.html]
        def create_vm_snapshot(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createVMSnapshot') 
          else
            options.merge!('command' => 'createVMSnapshot', 
            'virtualmachineid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

