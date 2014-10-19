module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updatePhysicalNetwork.html]
        def update_physical_network(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updatePhysicalNetwork') 
          else
            options.merge!('command' => 'updatePhysicalNetwork', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

