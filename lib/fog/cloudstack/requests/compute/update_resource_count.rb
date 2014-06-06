module Fog
  module Compute
    class Cloudstack

      class Real
        # Recalculate and update resource count for an account or domain.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateResourceCount.html]
        def update_resource_count(domainid, options={})
          options.merge!(
            'command' => 'updateResourceCount', 
            'domainid' => domainid  
          )
          request(options)
        end
      end

    end
  end
end

