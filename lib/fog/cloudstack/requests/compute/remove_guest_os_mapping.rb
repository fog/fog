module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a Guest OS Mapping.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeGuestOsMapping.html]
        def remove_guest_os_mapping(options={})
          request(options)
        end


        def remove_guest_os_mapping(id, options={})
          options.merge!(
            'command' => 'removeGuestOsMapping', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

