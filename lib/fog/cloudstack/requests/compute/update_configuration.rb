module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a configuration.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateConfiguration.html]
        def update_configuration(options={})
          options.merge!(
            'command' => 'updateConfiguration', 
            'name' => options['name']  
          )
          request(options)
        end
      end

    end
  end
end

