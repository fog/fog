module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updatePod.html]
        def update_pod(id, options={})
          options.merge!(
            'command' => 'updatePod', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

