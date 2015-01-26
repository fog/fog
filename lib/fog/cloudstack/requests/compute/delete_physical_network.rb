module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Physical Network.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deletePhysicalNetwork.html]
        def delete_physical_network(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deletePhysicalNetwork') 
          else
            options.merge!('command' => 'deletePhysicalNetwork', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

