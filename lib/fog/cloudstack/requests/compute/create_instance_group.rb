module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a vm group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createInstanceGroup.html]
        def create_instance_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createInstanceGroup') 
          else
            options.merge!('command' => 'createInstanceGroup', 
            'name' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

