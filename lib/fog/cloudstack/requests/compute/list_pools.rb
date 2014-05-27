module Fog
  module Compute
    class Cloudstack

      class Real
        # List Pool
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listPools.html]
        def list_pools(options={})
          options.merge!(
            'command' => 'listPools'  
          )
          request(options)
        end
      end

    end
  end
end

