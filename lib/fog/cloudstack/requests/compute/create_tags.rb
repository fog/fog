  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates resource tag(s)
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createTags.html]
          def create_tags(options={})
            options.merge!(
              'command' => 'createTags'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
