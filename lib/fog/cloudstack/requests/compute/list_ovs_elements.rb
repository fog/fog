module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available ovs elements.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listOvsElements.html]
        def list_ovs_elements(options={})
          request(options)
        end


        def list_ovs_elements(options={})
          options.merge!(
            'command' => 'listOvsElements'  
          )
          request(options)
        end
      end

    end
  end
end

