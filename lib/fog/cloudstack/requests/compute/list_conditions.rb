module Fog
  module Compute
    class Cloudstack

      class Real
        # List Conditions for the specific user
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listConditions.html]
        def list_conditions(options={})
          options.merge!(
            'command' => 'listConditions'  
          )
          request(options)
        end
      end

    end
  end
end

