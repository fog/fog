module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures an ovs element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/configureOvsElement.html]
        def configure_ovs_element(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'configureOvsElement') 
          else
            options.merge!('command' => 'configureOvsElement', 
            'id' => args[0], 
            'enabled' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

