module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteHost.html]
        def delete_host(id, options={})
          options.merge!(
            'command' => 'deleteHost', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

