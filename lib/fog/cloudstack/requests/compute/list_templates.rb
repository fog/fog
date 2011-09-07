module Fog
  module Compute
    class Cloudstack
      class Real

        # List all public, private, and privileged templates.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listTemplates.html]
        def list_templates(options={})
          options.merge!(
            'command' => 'listTemplates'
          )
          
          request(options)
        end

      end
    end
  end
end
