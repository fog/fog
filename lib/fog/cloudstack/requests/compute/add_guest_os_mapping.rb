module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a guest OS name to hypervisor OS name mapping
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addGuestOsMapping.html]
        def add_guest_os_mapping(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addGuestOsMapping') 
          else
            options.merge!('command' => 'addGuestOsMapping', 
            'hypervisor' => args[0], 
            'osnameforhypervisor' => args[1], 
            'hypervisorversion' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

