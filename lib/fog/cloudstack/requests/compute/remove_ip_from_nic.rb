module Fog
  module Compute
    class Cloudstack

      class Real
        # Assigns secondary IP to NIC.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeIpFromNic.html]
        def remove_ip_from_nic(id, options={})
          options.merge!(
            'command' => 'removeIpFromNic', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

