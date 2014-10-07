module Fog
  module Compute
    class Cloudstack

      class Real
        # Remove a VMware datacenter from a zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/removeVmwareDc.html]
        def remove_vmware_dc(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'removeVmwareDc') 
          else
            options.merge!('command' => 'removeVmwareDc', 
            'zoneid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

