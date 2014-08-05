module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists capabilities
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listCapabilities.html]
        def list_capabilities(options={})
          options.merge!(
            'command' => 'listCapabilities'  
          )
          request(options)
        end
      end

    end
  end
end

