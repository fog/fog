module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Region
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addRegion.html]
        def add_region(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addRegion') 
          else
            options.merge!('command' => 'addRegion', 
            'id' => args[0], 
            'name' => args[1], 
            'endpoint' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

