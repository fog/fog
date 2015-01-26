module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all supported OS categories for this cloud.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listOsCategories.html]
        def list_os_categories(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listOsCategories') 
          else
            options.merge!('command' => 'listOsCategories')
          end
          request(options)
        end
      end

    end
  end
end

