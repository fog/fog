module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates attributes of a template.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/user/updateTemplate.html]
        def update_template(options={})
          options.merge!(
            'command' => 'updateTemplate'
          )

          request(options)
        end

      end
    end
  end
end
