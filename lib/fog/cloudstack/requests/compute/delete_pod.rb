module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deletePod.html]
        def delete_pod(options={})
          options.merge!(
            'command' => 'deletePod', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

