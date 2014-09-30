module Fog
  module Compute
    class Cloudstack

      class Real
        # Detaches any ISO file (if any) currently attached to a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/detachIso.html]
        def detach_iso(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'detachIso') 
          else
            options.merge!('command' => 'detachIso', 
            'virtualmachineid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

