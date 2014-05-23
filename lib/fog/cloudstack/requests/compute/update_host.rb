module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateHost.html]
        def update_host(options={})
          options.merge!(
            'command' => 'updateHost',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

