module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists affinity group types available
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listAffinityGroupTypes.html]
        def list_affinity_group_types(options={})
          options.merge!(
            'command' => 'listAffinityGroupTypes'  
          )
          request(options)
        end
      end

    end
  end
end

