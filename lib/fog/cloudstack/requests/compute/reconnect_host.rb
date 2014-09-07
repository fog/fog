module Fog
  module Compute
    class Cloudstack

      class Real
        # Reconnects a host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/reconnectHost.html]
        def reconnect_host(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'reconnectHost') 
          else
            options.merge!('command' => 'reconnectHost', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

