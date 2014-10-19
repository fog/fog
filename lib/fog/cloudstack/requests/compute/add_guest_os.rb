module Fog
  module Compute
    class Cloudstack

      class Real
        # Add a new guest OS type
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addGuestOs.html]
        def add_guest_os(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addGuestOs') 
          else
            options.merge!('command' => 'addGuestOs', 
            'osdisplayname' => args[0], 
            'oscategoryid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

