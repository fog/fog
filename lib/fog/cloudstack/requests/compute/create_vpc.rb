module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createVPC.html]
        def create_vpc(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createVPC') 
          else
            options.merge!('command' => 'createVPC', 
            'vpcofferingid' => args[0], 
            'zoneid' => args[1], 
            'name' => args[2], 
            'cidr' => args[3], 
            'displaytext' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

