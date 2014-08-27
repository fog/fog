module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all Pods.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listPods.html]
        def list_pods(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listPods') 
          else
            options.merge!('command' => 'listPods')
          end
          request(options)
        end
      end

    end
  end
end

