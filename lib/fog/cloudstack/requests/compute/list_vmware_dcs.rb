module Fog
  module Compute
    class Cloudstack

      class Real
        # Retrieves VMware DC(s) associated with a zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVmwareDcs.html]
        def list_vmware_dcs(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVmwareDcs') 
          else
            options.merge!('command' => 'listVmwareDcs', 
            'zoneid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

