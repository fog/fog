module Fog
  module Compute
    class Cloudstack

      class Real
        # Cleanups VM reservations in the database.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/cleanVMReservations.html]
        def clean_vmreservations(options={})
          options.merge!(
            'command' => 'cleanVMReservations'  
          )
          request(options)
        end
      end

    end
  end
end

