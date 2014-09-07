module Fog
  module Compute
    class Cloudstack

      class Real
        # Prepares a host for maintenance.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/prepareHostForMaintenance.html]
        def prepare_host_for_maintenance(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'prepareHostForMaintenance') 
          else
            options.merge!('command' => 'prepareHostForMaintenance', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

