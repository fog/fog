module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a condition
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createCondition.html]
        def create_condition(options={})
          options.merge!(
            'command' => 'createCondition',
            'threshold' => options['threshold'], 
            'counterid' => options['counterid'], 
            'relationaloperator' => options['relationaloperator'], 
             
          )
          request(options)
        end
      end

    end
  end
end

