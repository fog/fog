module Fog
  module Compute
    class Cloudstack

      class Real
        # Add a new guest OS type
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addGuestOs.html]
        def add_guest_os(options={})
          request(options)
        end


        def add_guest_os(osdisplayname, oscategoryid, options={})
          options.merge!(
            'command' => 'addGuestOs', 
            'osdisplayname' => osdisplayname, 
            'oscategoryid' => oscategoryid  
          )
          request(options)
        end
      end

    end
  end
end

