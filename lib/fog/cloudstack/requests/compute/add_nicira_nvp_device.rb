module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Nicira NVP device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addNiciraNvpDevice.html]
        def add_nicira_nvp_device(options={})
          options.merge!(
            'command' => 'addNiciraNvpDevice', 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'password' => options['password'], 
            'transportzoneuuid' => options['transportzoneuuid'], 
            'hostname' => options['hostname'], 
            'username' => options['username']  
          )
          request(options)
        end
      end

    end
  end
end

