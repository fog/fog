module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an affinity/anti-affinity group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAffinityGroup.html]
        def create_affinity_group(options={})
          request(options)
        end


        def create_affinity_group(type, name, options={})
          options.merge!(
            'command' => 'createAffinityGroup', 
            'type' => type, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

