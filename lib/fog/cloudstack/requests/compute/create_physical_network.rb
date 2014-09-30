module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createPhysicalNetwork.html]
        def create_physical_network(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createPhysicalNetwork') 
          else
            options.merge!('command' => 'createPhysicalNetwork', 
            'name' => args[0], 
            'zoneid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

