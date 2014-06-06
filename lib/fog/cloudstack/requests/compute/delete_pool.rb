module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete a pool
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deletePool.html]
        def delete_pool(poolname, options={})
          options.merge!(
            'command' => 'deletePool', 
            'poolname' => poolname  
          )
          request(options)
        end
      end

    end
  end
end

