module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a Guest OS from listing.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeGuestOs.html]
        def remove_guest_os(options={})
          request(options)
        end


        def remove_guest_os(id, options={})
          options.merge!(
            'command' => 'removeGuestOs', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

