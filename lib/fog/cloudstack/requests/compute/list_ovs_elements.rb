module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available ovs elements.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listOvsElements.html]
        def list_ovs_elements(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listOvsElements') 
          else
            options.merge!('command' => 'listOvsElements')
          end
          request(options)
        end
      end

    end
  end
end

