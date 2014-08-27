module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists capabilities
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listCapabilities.html]
        def list_capabilities(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listCapabilities') 
          else
            options.merge!('command' => 'listCapabilities')
          end
          request(options)
        end
      end

    end
  end
end

