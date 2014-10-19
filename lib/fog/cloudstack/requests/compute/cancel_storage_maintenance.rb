module Fog
  module Compute
    class Cloudstack

      class Real
        # Cancels maintenance for primary storage
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/cancelStorageMaintenance.html]
        def cancel_storage_maintenance(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'cancelStorageMaintenance') 
          else
            options.merge!('command' => 'cancelStorageMaintenance', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

