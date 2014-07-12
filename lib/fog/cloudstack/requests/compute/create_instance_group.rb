module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a vm group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createInstanceGroup.html]
        def create_instance_group(name, options={})
          options.merge!(
            'command' => 'createInstanceGroup', 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

