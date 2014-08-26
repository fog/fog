module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deletePod.html]
        def delete_pod(id, options={})
          options.merge!(
            'command' => 'deletePod', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

