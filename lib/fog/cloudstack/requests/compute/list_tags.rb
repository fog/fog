module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists resource tags.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.2/user/listTags.html]
        def list_tags(options={})
          options.merge!(
            'command' => 'listTags'
          )

          request(options)
        end

      end
    end
  end
end
