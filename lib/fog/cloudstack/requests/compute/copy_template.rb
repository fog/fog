module Fog
  module Compute
    class Cloudstack
      class Real

        # Copy a template from one zoen to another
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.2/user/copyTemplate.html]
        def copy_template(options={})
          options.merge!(
              'command' => 'copyTemplate'
          )

          request(options)
        end

      end
    end
  end
end
