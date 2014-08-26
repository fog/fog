module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVPC.html]
        def create_vpc(options={})
          request(options)
        end


        def create_vpc(vpcofferingid, zoneid, name, cidr, displaytext, options={})
          options.merge!(
            'command' => 'createVPC', 
            'vpcofferingid' => vpcofferingid, 
            'zoneid' => zoneid, 
            'name' => name, 
            'cidr' => cidr, 
            'displaytext' => displaytext  
          )
          request(options)
        end
      end

    end
  end
end

