module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available networks.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listNetworks.html]
        def list_networks(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listNetworks') 
          else
            options.merge!('command' => 'listNetworks')
          end
          request(options)
        end
      end

    end
  end
end

