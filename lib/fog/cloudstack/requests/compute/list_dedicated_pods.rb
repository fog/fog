module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists dedicated pods.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listDedicatedPods.html]
        def list_dedicated_pods(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listDedicatedPods') 
          else
            options.merge!('command' => 'listDedicatedPods')
          end
          request(options)
        end
      end

    end
  end
end

