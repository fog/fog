module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a condition
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createCondition.html]
        def create_condition(options={})
          request(options)
        end


        def create_condition(threshold, relationaloperator, counterid, options={})
          options.merge!(
            'command' => 'createCondition', 
            'threshold' => threshold, 
            'relationaloperator' => relationaloperator, 
            'counterid' => counterid  
          )
          request(options)
        end
      end

    end
  end
end

