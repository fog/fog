module Fog
  module Compute
    class Cloudstack

      class Real
        # Cleanups VM reservations in the database.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/cleanVMReservations.html]
        def clean_vmreservations(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'cleanVMReservations') 
          else
            options.merge!('command' => 'cleanVMReservations')
          end
          request(options)
        end
      end

    end
  end
end

