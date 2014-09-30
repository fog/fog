module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Nicira NVP device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addNiciraNvpDevice.html]
        def add_nicira_nvp_device(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addNiciraNvpDevice') 
          else
            options.merge!('command' => 'addNiciraNvpDevice', 
            'physicalnetworkid' => args[0], 
            'transportzoneuuid' => args[1], 
            'username' => args[2], 
            'password' => args[3], 
            'hostname' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

