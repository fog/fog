module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a specified template.
        #
        # {CloudStack API Reference}[http://http://download.cloud.com/releases/3.0.0/api_3.0.0/user/deleteTemplate.html]
        def delete_template(options={})
          options.merge!(
            'command' => 'deleteTemplate'
          )

          request(options)
        end

      end
    end
  end
end
