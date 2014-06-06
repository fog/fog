module Fog
  module Compute
    class Cloudstack

      class Real
        # Assigns secondary IP to NIC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addIpToNic.html]
        def add_ip_to_nic(nicid, options={})
          options.merge!(
            'command' => 'addIpToNic', 
            'nicid' => nicid  
          )
          request(options)
        end
      end

    end
  end
end

