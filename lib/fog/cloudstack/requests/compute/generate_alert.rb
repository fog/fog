module Fog
  module Compute
    class Cloudstack

      class Real
        # Generates an alert
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/generateAlert.html]
        def generate_alert(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'generateAlert') 
          else
            options.merge!('command' => 'generateAlert', 
            'description' => args[0], 
            'name' => args[1], 
            'type' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

