module Fog
  module Compute
    class Cloudstack

      class Real
        # lists all available apis on the server, provided by the Api Discovery plugin
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listApis.html]
        def list_apis(options={})
          options.merge!(
            'command' => 'listApis'  
          )
          request(options)
        end
      end

    end
  end
end

