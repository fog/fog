module Fog
  module Compute
    class Cloudstack

      class Real
        # Stops a system VM.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/stopSystemVm.html]
        def stop_system_vm(options={})
          options.merge!(
            'command' => 'stopSystemVm', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

