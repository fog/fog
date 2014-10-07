module Fog
  module Compute
    class Cloudstack

      class Real
        # List private gateways
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listPrivateGateways.html]
        def list_private_gateways(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listPrivateGateways') 
          else
            options.merge!('command' => 'listPrivateGateways')
          end
          request(options)
        end
      end

    end
  end
end

