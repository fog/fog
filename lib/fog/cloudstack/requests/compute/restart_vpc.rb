module Fog
  module Compute
    class Cloudstack

      class Real
        # Restarts a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/restartVPC.html]
        def restart_vpc(id, options={})
          options.merge!(
            'command' => 'restartVPC', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

