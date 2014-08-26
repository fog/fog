module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes VPC offering
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteVPCOffering.html]
        def delete_vpcoffering(id, options={})
          options.merge!(
            'command' => 'deleteVPCOffering', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

