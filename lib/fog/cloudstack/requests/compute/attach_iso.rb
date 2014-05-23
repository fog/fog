module Fog
  module Compute
    class Cloudstack

      class Real
        # Attaches an ISO to a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/attachIso.html]
        def attach_iso(options={})
          options.merge!(
            'command' => 'attachIso',
            'virtualmachineid' => options['virtualmachineid'], 
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

