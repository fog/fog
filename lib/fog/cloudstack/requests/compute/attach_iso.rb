module Fog
  module Compute
    class Cloudstack

      class Real
        # Attaches an ISO to a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/attachIso.html]
        def attach_iso(id, virtualmachineid, options={})
          options.merge!(
            'command' => 'attachIso', 
            'id' => id, 
            'virtualmachineid' => virtualmachineid  
          )
          request(options)
        end
      end

    end
  end
end

