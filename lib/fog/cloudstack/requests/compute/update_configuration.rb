module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a configuration.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateConfiguration.html]
        def update_configuration(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateConfiguration') 
          else
            options.merge!('command' => 'updateConfiguration', 
            'name' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

