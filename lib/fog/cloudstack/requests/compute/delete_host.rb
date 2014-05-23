module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteHost.html]
        def delete_host(options={})
          options.merge!(
            'command' => 'deleteHost',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

