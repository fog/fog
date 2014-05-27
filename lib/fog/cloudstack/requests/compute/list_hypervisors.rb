module Fog
  module Compute
    class Cloudstack

      class Real
        # List hypervisors
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listHypervisors.html]
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

