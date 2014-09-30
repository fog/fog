module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists physical networks
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listPhysicalNetworks.html]
        def list_physical_networks(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listPhysicalNetworks') 
          else
            options.merge!('command' => 'listPhysicalNetworks')
          end
          request(options)
        end
      end

    end
  end
end

