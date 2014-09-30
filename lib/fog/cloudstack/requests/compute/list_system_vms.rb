module Fog
  module Compute
    class Cloudstack

      class Real
        # List system virtual machines.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listSystemVms.html]
        def list_system_vms(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listSystemVms') 
          else
            options.merge!('command' => 'listSystemVms')
          end
          request(options)
        end
      end

    end
  end
end

