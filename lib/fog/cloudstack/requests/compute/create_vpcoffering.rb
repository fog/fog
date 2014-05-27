module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates VPC offering
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVPCOffering.html]
        def create_vpcoffering(options={})
          options.merge!(
            'command' => 'createVPCOffering', 
            'supportedservices' => options['supportedservices'], 
            'displaytext' => options['displaytext'], 
            'name' => options['name']  
          )
          request(options)
        end
      end

    end
  end
end

