module Fog
  module Compute
    class Cloudstack
      class Real

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


