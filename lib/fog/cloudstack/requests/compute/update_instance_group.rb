module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a vm group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateInstanceGroup.html]
        def update_instance_group(id, options={})
          options.merge!(
            'command' => 'updateInstanceGroup', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

