module Fog
  module Compute
    class Cloudstack

      class Real
        # Cancels host maintenance.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/cancelHostMaintenance.html]
        def cancel_host_maintenance(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'cancelHostMaintenance') 
          else
            options.merge!('command' => 'cancelHostMaintenance', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

