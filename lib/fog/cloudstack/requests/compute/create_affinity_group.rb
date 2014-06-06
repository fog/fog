module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an affinity/anti-affinity group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAffinityGroup.html]
        def create_affinity_group(name, type, options={})
          options.merge!(
            'command' => 'createAffinityGroup', 
            'name' => name, 
            'type' => type  
          )
          request(options)
        end
      end

    end
  end
end

