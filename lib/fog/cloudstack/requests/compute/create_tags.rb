module Fog
  module Compute
    class Cloudstack
      class Real

        # creates resource tags.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.2/user/createTags.html]
        def create_tags(options={})
          options.merge!(
            'command' => 'createTags'
          )

          request(options)
        end

      end
    end
  end
end
