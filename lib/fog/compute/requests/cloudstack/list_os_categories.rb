module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all supported OS categories for this cloud.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listOsCategories.html]
        def list_os_categories(options={})
          options.merge!(
            'command' => 'listOsCategories'
          )
          
          request(options)
        end

      end
    end
  end
end


