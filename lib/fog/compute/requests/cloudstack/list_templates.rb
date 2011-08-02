module Fog
  module Compute
    class Cloudstack
      class Real

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
