module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates VPC offering
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateVPCOffering.html]
        def update_vpcoffering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateVPCOffering') 
          else
            options.merge!('command' => 'updateVPCOffering', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

