module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an ip address
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateIpAddress.html]
        def update_ip_address(options={})
          request(options)
        end


        def update_ip_address(id, options={})
          options.merge!(
            'command' => 'updateIpAddress', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

