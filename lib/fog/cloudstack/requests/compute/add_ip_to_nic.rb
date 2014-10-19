module Fog
  module Compute
    class Cloudstack

      class Real
        # Assigns secondary IP to NIC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addIpToNic.html]
        def add_ip_to_nic(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addIpToNic') 
          else
            options.merge!('command' => 'addIpToNic', 
            'nicid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

