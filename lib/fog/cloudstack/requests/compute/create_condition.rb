module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a condition
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createCondition.html]
        def create_condition(relationaloperator, threshold, counterid, options={})
          options.merge!(
            'command' => 'createCondition', 
            'relationaloperator' => relationaloperator, 
            'threshold' => threshold, 
            'counterid' => counterid  
          )
          request(options)
        end
      end

    end
  end
end

