module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates the information about Guest OS
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateGuestOs.html]
        def update_guest_os(options={})
          request(options)
        end


        def update_guest_os(id, osdisplayname, options={})
          options.merge!(
            'command' => 'updateGuestOs', 
            'id' => id, 
            'osdisplayname' => osdisplayname  
          )
          request(options)
        end
      end

    end
  end
end

