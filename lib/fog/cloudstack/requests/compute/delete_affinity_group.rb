module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes affinity group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteAffinityGroup.html]
        def delete_affinity_group(options={})
          options.merge!(
            'command' => 'deleteAffinityGroup'  
          )
          request(options)
        end
      end

    end
  end
end

