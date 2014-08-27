module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a template from the system. All virtual machines using the deleted template will not be affected.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteTemplate.html]
        def delete_template(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteTemplate') 
          else
            options.merge!('command' => 'deleteTemplate', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

