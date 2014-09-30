module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a vm group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateInstanceGroup.html]
        def update_instance_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateInstanceGroup') 
          else
            options.merge!('command' => 'updateInstanceGroup', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

