module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes specified region
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/removeRegion.html]
        def remove_region(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'removeRegion') 
          else
            options.merge!('command' => 'removeRegion', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

