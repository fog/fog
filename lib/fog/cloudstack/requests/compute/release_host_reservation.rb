module Fog
  module Compute
    class Cloudstack

      class Real
        # Releases host reservation.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/releaseHostReservation.html]
        def release_host_reservation(id, options={})
          options.merge!(
            'command' => 'releaseHostReservation', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

