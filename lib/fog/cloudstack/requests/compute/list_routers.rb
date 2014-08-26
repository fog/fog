module Fog
  module Compute
    class Cloudstack

      class Real
        # List routers.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listRouters.html]
        def list_routers(options={})
          options.merge!(
            'command' => 'listRouters'  
          )
          request(options)
        end
      end

    end
  end
end

