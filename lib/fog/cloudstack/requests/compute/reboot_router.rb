module Fog
  module Compute
    class Cloudstack

      class Real
        # Starts a router.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/rebootRouter.html]
        def reboot_router(options={})
          options.merge!(
            'command' => 'rebootRouter', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

