module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures an ovs element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/configureOvsElement.html]
        def configure_ovs_element(options={})
          request(options)
        end


        def configure_ovs_element(id, enabled, options={})
          options.merge!(
            'command' => 'configureOvsElement', 
            'id' => id, 
            'enabled' => enabled  
          )
          request(options)
        end
      end

    end
  end
end

