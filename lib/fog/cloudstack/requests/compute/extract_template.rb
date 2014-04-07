module Fog
  module Compute
    class Cloudstack
      class Real

        # Extracts a template.
        #
        # {CloudStack API Reference}[http://http://download.cloud.com/releases/3.0.0/api_3.0.0/user/extractTemplate.html]
        def extract_template(options={})
          options.merge!(
            'command' => 'extractTemplate'
          )

          request(options)
        end

      end
    end
  end
end
