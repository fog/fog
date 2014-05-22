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
            'cidr' => options['cidr'], 
            'zoneid' => options['zoneid'], 
            'displaytext' => options['displaytext'], 
            'name' => options['name'], 
            'vpcofferingid' => options['vpcofferingid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

