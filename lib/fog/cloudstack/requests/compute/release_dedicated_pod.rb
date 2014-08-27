module Fog
  module Compute
    class Cloudstack

      class Real
        # Release the dedication for the pod
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/releaseDedicatedPod.html]
        def release_dedicated_pod(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'releaseDedicatedPod') 
          else
            options.merge!('command' => 'releaseDedicatedPod', 
            'podid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

