module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes resource tags.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.2/user/deleteTags.html]
        def delete_tags(options={})
          options.merge!(
            'command' => 'deleteTags'
          )

          request(options)
        end

      end
    end
  end
end
