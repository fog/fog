module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a condition
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteCondition.html]
        def delete_condition(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteCondition') 
          else
            options.merge!('command' => 'deleteCondition', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

