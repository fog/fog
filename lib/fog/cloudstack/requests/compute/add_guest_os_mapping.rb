module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a guest OS name to hypervisor OS name mapping
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addGuestOsMapping.html]
        def add_guest_os_mapping(options={})
          request(options)
        end


        def add_guest_os_mapping(hypervisor, osnameforhypervisor, hypervisorversion, options={})
          options.merge!(
            'command' => 'addGuestOsMapping', 
            'hypervisor' => hypervisor, 
            'osnameforhypervisor' => osnameforhypervisor, 
            'hypervisorversion' => hypervisorversion  
          )
          request(options)
        end
      end

    end
  end
end

