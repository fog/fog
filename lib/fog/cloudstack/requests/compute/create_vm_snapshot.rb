module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates snapshot for a vm.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVMSnapshot.html]
        def create_vm_snapshot(options={})
          options.merge!(
            'command' => 'createVMSnapshot', 
            'virtualmachineid' => options['virtualmachineid']  
          )
          request(options)
        end
      end

    end
  end
end

