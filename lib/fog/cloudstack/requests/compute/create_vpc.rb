module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVPC.html]
        def create_vpc(options={})
          options.merge!(
            'command' => 'createVPC', 
            'vpcofferingid' => options['vpcofferingid'], 
            'name' => options['name'], 
            'zoneid' => options['zoneid'], 
            'displaytext' => options['displaytext'], 
            'cidr' => options['cidr']  
          )
          request(options)
        end
      end

    end
  end
end

