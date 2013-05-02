  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all supported OS categories for this cloud.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listOsCategories.html]
          def list_os_categories(options={})
            options.merge!(
              'command' => 'listOsCategories'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
