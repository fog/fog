module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all children domains belonging to a specified domain.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listDomainChildren.html]
        def list_domain_children(options={})
          options.merge!(
            'command' => 'listDomainChildren'
          )
          
          request(options)
        end

      end
    end
  end
end
