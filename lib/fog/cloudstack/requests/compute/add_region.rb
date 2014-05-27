module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Region
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addRegion.html]
        def add_region(options={})
          options.merge!(
            'command' => 'addRegion', 
            'name' => options['name'], 
            'endpoint' => options['endpoint'], 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

