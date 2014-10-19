module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updatePod.html]
        def update_pod(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updatePod') 
          else
            options.merge!('command' => 'updatePod', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

