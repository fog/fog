module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVPC.html]
        def create_vpc(cidr, vpcofferingid, name, displaytext, zoneid, options={})
          options.merge!(
            'command' => 'createVPC', 
            'cidr' => cidr, 
            'vpcofferingid' => vpcofferingid, 
            'name' => name, 
            'displaytext' => displaytext, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

