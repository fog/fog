module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates the information about Guest OS to Hypervisor specific name mapping
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateGuestOsMapping.html]
        def update_guest_os_mapping(options={})
          request(options)
        end


        def update_guest_os_mapping(osnameforhypervisor, id, options={})
          options.merge!(
            'command' => 'updateGuestOsMapping', 
            'osnameforhypervisor' => osnameforhypervisor, 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

