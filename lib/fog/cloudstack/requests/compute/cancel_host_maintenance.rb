module Fog
  module Compute
    class Cloudstack

      class Real
        # Cancels host maintenance.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/cancelHostMaintenance.html]
        def cancel_host_maintenance(options={})
          options.merge!(
            'command' => 'cancelHostMaintenance', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

