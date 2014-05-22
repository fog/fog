module Fog
  module Compute
    class Cloudstack

      class Real
        # Release the dedication for the pod
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/releaseDedicatedPod.html]
        def release_dedicated_pod(options={})
          options.merge!(
            'command' => 'releaseDedicatedPod',
            'podid' => options['podid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

