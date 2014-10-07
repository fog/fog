module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available network offerings.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listNetworkOfferings.html]
        def list_network_offerings(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listNetworkOfferings') 
          else
            options.merge!('command' => 'listNetworkOfferings')
          end
          request(options)
        end
      end

    end
  end
end

