module Fog
  module Compute
    class Cloudstack

      class Real
        # Prepares a host for maintenance.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/prepareHostForMaintenance.html]
        def prepare_host_for_maintenance(id, options={})
          options.merge!(
            'command' => 'prepareHostForMaintenance', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

