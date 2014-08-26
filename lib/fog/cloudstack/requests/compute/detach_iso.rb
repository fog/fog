module Fog
  module Compute
    class Cloudstack

      class Real
        # Detaches any ISO file (if any) currently attached to a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/detachIso.html]
        def detach_iso(virtualmachineid, options={})
          options.merge!(
            'command' => 'detachIso', 
            'virtualmachineid' => virtualmachineid  
          )
          request(options)
        end
      end

    end
  end
end

