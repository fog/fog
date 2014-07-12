module Fog
  module Compute
    class Cloudstack

      class Real
        # Reconnects a host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/reconnectHost.html]
        def reconnect_host(id, options={})
          options.merge!(
            'command' => 'reconnectHost', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

