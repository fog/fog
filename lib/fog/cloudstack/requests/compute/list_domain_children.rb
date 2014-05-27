module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all children domains belonging to a specified domain
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listDomainChildren.html]
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

