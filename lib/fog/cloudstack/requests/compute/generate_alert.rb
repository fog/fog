module Fog
  module Compute
    class Cloudstack

      class Real
        # Generates an alert
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/generateAlert.html]
        def generate_alert(options={})
          request(options)
        end


        def generate_alert(description, name, type, options={})
          options.merge!(
            'command' => 'generateAlert', 
            'description' => description, 
            'name' => name, 
            'type' => type  
          )
          request(options)
        end
      end

    end
  end
end

