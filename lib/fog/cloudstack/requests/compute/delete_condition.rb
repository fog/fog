module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a condition
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteCondition.html]
        def delete_condition(id, options={})
          options.merge!(
            'command' => 'deleteCondition', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

