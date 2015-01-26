module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates VPC offering
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createVPCOffering.html]
        def create_vpcoffering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createVPCOffering') 
          else
            options.merge!('command' => 'createVPCOffering', 
            'supportedservices' => args[0], 
            'name' => args[1], 
            'displaytext' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

