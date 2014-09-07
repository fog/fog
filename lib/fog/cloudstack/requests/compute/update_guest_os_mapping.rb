module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates the information about Guest OS to Hypervisor specific name mapping
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateGuestOsMapping.html]
        def update_guest_os_mapping(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateGuestOsMapping') 
          else
            options.merge!('command' => 'updateGuestOsMapping', 
            'osnameforhypervisor' => args[0], 
            'id' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

