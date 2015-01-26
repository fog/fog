module Fog
  module Compute
    class Cloudstack

      class Real
        # Stops a system VM.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/stopSystemVm.html]
        def stop_system_vm(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'stopSystemVm') 
          else
            options.merge!('command' => 'stopSystemVm', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

