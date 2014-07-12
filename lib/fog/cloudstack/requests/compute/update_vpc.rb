module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVPC.html]
        def update_vpc(id, name, options={})
          options.merge!(
            'command' => 'updateVPC', 
            'id' => id, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

