module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates resource limits for an account or domain.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateResourceLimit.html]
        def update_resource_limit(options={})
          options.merge!(
            'command' => 'updateResourceLimit',
            'resourcetype' => options['resourcetype'], 
             
          )
          request(options)
        end
      end

    end
  end
end

