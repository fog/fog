module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all configurations.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listConfigurations.html]
        def list_configurations(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listConfigurations') 
          else
            options.merge!('command' => 'listConfigurations')
          end
          request(options)
        end
      end

    end
  end
end

