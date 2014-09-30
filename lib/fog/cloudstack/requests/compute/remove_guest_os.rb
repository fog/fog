module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a Guest OS from listing.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/removeGuestOs.html]
        def remove_guest_os(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'removeGuestOs') 
          else
            options.merge!('command' => 'removeGuestOs', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

