module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists affinity groups
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listAffinityGroups.html]
        def list_affinity_groups(options={})
          options.merge!(
            'command' => 'listAffinityGroups'  
          )
          request(options)
        end
      end

    end
  end
end

