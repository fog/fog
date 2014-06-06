module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a vm group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteInstanceGroup.html]
        def delete_instance_group(id, options={})
          options.merge!(
            'command' => 'deleteInstanceGroup', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

