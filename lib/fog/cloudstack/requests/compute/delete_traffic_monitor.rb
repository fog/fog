module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an traffic monitor host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteTrafficMonitor.html]
        def delete_traffic_monitor(options={})
          options.merge!(
            'command' => 'deleteTrafficMonitor',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

