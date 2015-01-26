module Fog
  module Compute
    class Cloudstack

      class Real
        # lists all available apis on the server, provided by the Api Discovery plugin
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listApis.html]
        def list_apis(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listApis') 
          else
            options.merge!('command' => 'listApis')
          end
          request(options)
        end
      end

    end
  end
end

