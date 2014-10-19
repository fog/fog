module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a condition
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createCondition.html]
        def create_condition(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createCondition') 
          else
            options.merge!('command' => 'createCondition', 
            'threshold' => args[0], 
            'relationaloperator' => args[1], 
            'counterid' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

