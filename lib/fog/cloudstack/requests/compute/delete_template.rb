module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a template from the system. All virtual machines using the deleted template will not be affected.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteTemplate.html]
        def delete_template(id, options={})
          options.merge!(
            'command' => 'deleteTemplate', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

