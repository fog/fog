module Fog
  module Compute
    class Cloudstack

      class Real
        # Create a pool
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPool.html]
        def create_pool(options={})
          options.merge!(
            'command' => 'createPool', 
            'algorithm' => options['algorithm'], 
            'name' => options['name']  
          )
          request(options)
        end
      end

    end
  end
end

