module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates attributes of a template.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateTemplate.html]
        def update_template(id, options={})
          options.merge!(
            'command' => 'updateTemplate', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

