module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a vm group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteInstanceGroup.html]
        def delete_instance_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteInstanceGroup') 
          else
            options.merge!('command' => 'deleteInstanceGroup', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

