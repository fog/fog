  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # List resource tag(s)
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listTags.html]
          def list_tags(options={})
            options.merge!(
              'command' => 'listTags'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
