  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deleting resource tag(s)
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteTags.html]
          def delete_tags(options={})
            options.merge!(
              'command' => 'deleteTags'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
