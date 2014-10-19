module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates the information about Guest OS
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateGuestOs.html]
        def update_guest_os(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateGuestOs') 
          else
            options.merge!('command' => 'updateGuestOs', 
            'id' => args[0], 
            'osdisplayname' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

