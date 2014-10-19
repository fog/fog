module Fog
  module Compute
    class Cloudstack

      class Real
        # Releases host reservation.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/releaseHostReservation.html]
        def release_host_reservation(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'releaseHostReservation') 
          else
            options.merge!('command' => 'releaseHostReservation', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

