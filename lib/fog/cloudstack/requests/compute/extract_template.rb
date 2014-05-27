module Fog
  module Compute
    class Cloudstack

      class Real
        # Extracts a template
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/extractTemplate.html]
        def extract_template(options={})
          options.merge!(
            'command' => 'extractTemplate', 
            'id' => options['id'], 
            'mode' => options['mode']  
          )
          request(options)
        end
      end

    end
  end
end

