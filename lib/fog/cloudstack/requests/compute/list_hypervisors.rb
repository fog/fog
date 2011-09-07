module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists hypervisors.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listHypervisors.html]
        def list_hypervisors(options={})
          options.merge!(
            'command' => 'listHypervisors'
          )
          
          request(options)
        end

      end
    end
  end
end
