module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteVPC.html]
        def delete_vpc(id, options={})
          options.merge!(
            'command' => 'deleteVPC', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

